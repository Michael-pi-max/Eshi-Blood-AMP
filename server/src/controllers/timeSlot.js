const TimeSlot = require('../models/timeSlot');

const { validationResult } = require("express-validator");
const User = require("../models/user");

exports.getAllTimeSlot = async (req, res, next) => {
    try{
        const errors = validationResult(req);
        if(!errors.isEmpty()) {
            return res.status(400).json({
                status: "error",
                message: errors.array()[0].msg,
            })
        }
        const page = req.query.page * 1 || 1;
        const limit = req.query.limit * 1 || 1;
        const result = await TimeSlot.paginate(
            { isDeleted: false },
            {
                page,
                limit,
                sort: "-createdAt",
            }
        );
        res.status(200).json({
            status: "succes",
            result,
        });
    }catch(error){
        console.log(error);
    }
};

exports.getTimeStlot = async (req, res, next) => {
    try{
        const errors = validationResult(req);
        if(!errors.isEmpty()){
            return res.status(400).json({
                status: "error",
                message: errors.array()[0].msg,
            });
        }
        const timeSlot = await TimeSlot.findById(req.params.id);
        if(!timeSlot){
            return res.status(404).json({
                status: "error",
                message: "Time SLot with this ID does not exist",
            });
        }
        if(timeSlot.isDeleted){
            return res.status(404).json({
                status: "error",
                message: "Role with this ID does not exist",
            });
        }
        res.status(200).json({
            status: "success",
            timeSlot,
        });
    }catch(error){
        console.log(error);
    }
};

exports.createTimeSlot = async (req, res, next) => {
    try{
        const error = validationResult(req);
        if(!error.isEmpty()){
            return res.status(400).json({
                status: "error",
                message: errors.array()[0].msg,
            });
        }

        const timeSlot = await TimeSlot.create({
            ...req.body,
        });
    }catch(error){
        console.log(error);
    }
};

exports.updateTimeSlot = async (req, res, next) => {
    try{
        const errors = validationResult(req);
        if(!errors.isEmpty()) {
            res.status(400).json({
                status: "error",
                message: errors.array()[0].msg,
            });
        }

        const timeSlot =await TimeSlot.findByIdAndUpdate(req.params.id);
        if(!timeSlot) {
            res.status(404).json({
                status: "error",
                message: "Time Slot with this ID does not exist",
            });
        }
        // if(timeSlot.isDeleted){
        //     res.status(404).json({
        //         status: "error",
        //         message: "Time Slot with this ID does not exist",
        //     });
        // }
        res.status(200).json({
            status: "succes",
            timeSlot,
        });
    }catch(error){
        console.log(error);
    }
};

exports.deleteTimeSlot = async (req, res, next) => {
    try{
        const errors = validationResult(req);
        
        if(!errors.isEmpty()) {
            res.status(404).json({
                status: "error",
                message: errors.array()[0].msg
            });
        }

        const timeSlot = await TimeSlot.findByIdAndUpdate(req.params.id, {
            isDeleted: true,
        });

        if(!role){
            return res.status(404).json({
                status: "error",
                message: "Time Slot with this ID does not exist",
            });
        }
        rest.status(200).json({
            status: "success",
            timeSlot: null,
        })
    }catch(error) {
        console.log(error);
    }
}

