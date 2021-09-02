import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eshiblood/src/request/bloc/request_event.dart';
import 'package:eshiblood/src/request/bloc/request_state.dart';
import 'package:eshiblood/src/request/request_repository/request_repository.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final RequestRepository requestRepository;
  RequestBloc({required this.requestRepository}) : super(RequestLoading());

  @override
  Stream<RequestState> mapEventToState(RequestEvent event) async* {
    if (event is RequestsLoad) {
      yield RequestLoading();
      try {
        final requests = await requestRepository.getRequests();
        yield RequestsLoadSuccess(requests);
      } catch (e) {
        yield RequestOperationFailure();
      }
    }
    if (event is RequestLoad) {
      yield RequestLoading();
      try {
        final request =
            await requestRepository.getRequest(event.request.id ?? "");
        yield RequestLoadSuccess(request);
      } catch (e) {
        yield RequestOperationFailure();
      }
    }
    if (event is RequestCreate) {
      yield RequestLoading();
      try {
        await requestRepository.createRequest(event.request);
        final request =
            await requestRepository.getRequest(event.request.id ?? "");
        yield RequestCreateSuccess(request);
      } catch (e) {
        yield RequestOperationFailure();
      }
    }
    if (event is RequestUpdate) {
      yield RequestLoading();
      try {
        await requestRepository.updateRequest(event.request);
        final request =
            await requestRepository.getRequest(event.request.id ?? "");
        yield RequestUpdateSuccess(request);
      } catch (e) {
        yield RequestOperationFailure();
      }
    }
    if (event is RequestDelete) {
      yield RequestLoading();
      try {
        await requestRepository.deleteRequest(event.request.id ?? "");
        yield RequestDeleteSuccess();
      } catch (e) {
        yield RequestOperationFailure();
      }
    }

    if (event is RequestAccept) {
      yield RequestLoading();
      try {
        var result =
            await requestRepository.acceptRequest(event.request.id ?? "");
        yield RequestAccepted(result);
      } catch (e) {
        yield RequestOperationFailure();
      }
    }
  }
}
