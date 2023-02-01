////////////////////////////////////////////// IMPORTS //////////////////////////////////////////////

// Import Mongoose
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//////////////////////////////////////////// SCHEMA AND MODEL ////////////////////////////////////////////

// Create Checklist Schema and Model
const ChecklistItemSchema = new Schema ({
    
    checklistTitle: {
              type: String
          },
          checklistItem: {
              type: String
          }, 
          isChecked: {
              type: Boolean
          },
          time: {
              type: String
          },
          createdBy: {
              type: String
          },
          taskTitle: {
              type: String
          },
    
  });
  

// Create Checklist Schema and Model
const ChecklistSchema = new Schema ({
    
  checklistTitle: {
            type: String
        },
        assignedTo: {
            type: String
        }, 
        
        createdBy: {
            type: String
        },
        taskTitle: {
            type: String
        },
        isChecked: {
            type: Boolean
        },
        time: {
            type: String
        },
        checklistItems: [ChecklistItemSchema],
  
});

//const ChecklistModel= mongoose.model('checklist_data', ChecklistSchema, 'checklist_data');
module.exports = ChecklistSchema;