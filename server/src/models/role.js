const mongoose = require("mongoose");
const mongoosePaginate = require("mongoose-paginate");

/**
 * Schema for storing role
 *  * roleName - role name
 *  * actions - role description
 *  *
 */
const schema = new mongoose.Schema(
  {
    roleName: {
      type: String,
    },

    privileges: {
      type: [
        {
          title: { type: String },
          permissions: {
            type: [],
            default: ["read", "create", "update", "delete"],
          },
        },
      ],
    },

    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    isDeleted: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

schema.plugin(mongoosePaginate);

const Role = mongoose.model("Role", schema);

module.exports = Role;
