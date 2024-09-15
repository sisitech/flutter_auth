const teacherOptions = {
  "name": "List Create Teachers Dynamics Api",
  "description": "Group statistics by:\n`type` = id, sub-county, county",
  "renders": ["application/json", "text/html"],
  "parses": [
    "application/json",
    "application/x-www-form-urlencoded",
    "multipart/form-data"
  ],
  "actions": {
    "POST": {
      "name": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Name",
        "max_length": 45
      },
      "id": {
        "type": "integer",
        "required": false,
        "read_only": true,
        "label": "ID"
      },
      "school_name": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "School name"
      },
      "username": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "Username"
      },
      "gender_name": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "Gender name"
      },
      "gender": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "Gender"
      },
      "tsc_no": {
        "type": "integer",
        "required": true,
        "read_only": false,
        "label": "Tsc Number",
        "max_length": 45,
        "show_only": "TSC",
        // "from_field": "role",
        "default": ""
      },
      "role_name": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "Role name"
      },
      "created": {
        "type": "date",
        "required": false,
        "read_only": false,
        "label": "Created",
        "start_value": "1985-08-14",
        "end_value": "today"
      },
      "modified": {
        "type": "date",
        "required": false,
        "read_only": false,
        "label": "Modified"
      },
      "first_name": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "First name",
        "max_length": 45
      },
      "middle_name": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Middle name",
        "max_length": 45
      },
      "contact_phone": {
        "type": "alphabets",
        "required": false,
        "read_only": false,
        "label": "Contact Phone",
      },
      "contact_name": {
        "type": "field",
        "required": false,
        "read_only": false,
        "label": "Contact name",
        "url": "api/v1/shops",
        "instance_url": "api/v1/shops/",
        "display_name": "name",
        "search_field": "name",
        "max_length": 45,
        "select_first": false,
        "placeholder": "The name of the customer to deliver to"
      },
      "contact_email": {
        "type": "multifield",
        "required": false,
        "read_only": false,
        "label": "Contact Email a",
        "url": "api/v1/users",
        "display_name": "username",
        "search_field": "usenarname",
        "max_length": 45,
        "value_field": "email",
        "placeholder": "Search by username ...",
        "show_reset_value": false,
      },
      "contact_email_test": {
        "type": "multifield",
        "multiple": false,
        "required": false,
        "read_only": false,
        "fetch_first": true,
        "label": "Select Shop",
        // "url": "api/v1/categories",
        "storage": "category",
        "display_name": "name",
        "search_field": "name",
        "max_length": 45,
        "value_field": "id",
        "placeholder": "Search by name ...",
        "show_reset_value": true,
      },
      "contact_email_e": {
        "type": "multifield",
        "multiple": true,
        "required": false,
        "read_only": false,
        "fetch_first": true,
        "label": "Contact Email ae",
        // "url": "api/v1/sub-categories",
        "storage": "subCategory",
        "from_field_value_field": "category",
        "display_name": "name",
        "search_field": "name",
        "max_length": 45,
        "value_field": "id",
        "from_field": "contact_email_test",
        "placeholder": "Search by username ...",
        "show_reset_value": true,
      },
      "active": {
        "type": "boolean",
        "required": true,
        "read_only": false,
        "label": "Active"
      },
      "location": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "Location",
        "max_length": 400
      },
      "last_name": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "Last name",
        "max_length": 45
      },
      "date_started_teaching": {
        "type": "date",
        "required": false,
        "read_only": false,
        "label": "Date started teaching"
      },
      "joined_current_school": {
        "type": "date",
        "required": false,
        "read_only": false,
        "label": "Joined current school"
      },
      "is_non_delete": {
        "type": "boolean",
        "required": false,
        "read_only": false,
        "label": "Is non delete"
      },
      "role": {
        "type": "choice",
        "required": false,
        "read_only": false,
        "label": "Teacher Type",
        "storage": "districts",
        // "url": "api/v1/shops",
        "display_name": "name",
        // "choices": [
        //   {"value": "TSC", "display_name": "TSC"},
        //   {"value": "BRD", "display_name": "BOM"}
        // ]
      },
      "phone": {
        "type": "multifield",
        "required": false,
        "read_only": false,
        "multiple": true,
        "label": "Phone Number",
        "max_length": 20,
        "display_name": "name",
        "from_field": "role",
        // "url": "api/v1/shehiyas",
        "from_field_value_field": "id",
        // "from_field_source": "shehiyas_details",
        // "storage": "shehiyas",
        "show_only": "2",
        "choices": [
          {"value": "TSC", "display_name": "TSC"},
          {"value": "BRD", "display_name": "BOM"}
        ]
      },
      "qualifications": {
        "type": "choice",
        "required": false,
        "read_only": false,
        "label": "Qualifications",
        "choices": [
          {"value": "NS", "display_name": "Not Set"},
          {"value": "UNI", "display_name": "UNIVERSITY"},
          {"value": "COL", "display_name": "COLLEGE"}
        ]
      },
      "is_school_admin": {
        "type": "boolean",
        "required": false,
        "read_only": false,
        "label": "Is school admin"
      },
      "email": {
        "type": "email",
        "required": true,
        "read_only": false,
        "label": "Email Address ( Used to receive account password )",
        "max_length": 100
      },
      "marital_status": {
        "type": "choice",
        "required": false,
        "read_only": false,
        "label": "Marital status",
        "choices": [
          {"value": "NS", "display_name": "Not Set"},
          {"value": "S", "display_name": "Single"},
          {"value": "M", "display_name": "Married"},
          {"value": "D", "display_name": "Divorced"}
        ]
      },
      "dob": {
        "type": "date",
        "required": false,
        "read_only": false,
        "label": "Date of Birth"
      },
      "moe_id": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Moe id",
        "max_length": 50
      },
      "user": {
        "type": "field",
        "required": false,
        "read_only": false,
        "label": "User"
      },
      "school": {
        "type": "multifield",
        "required": true,
        "read_only": false,
        "label": "Assign School",
        "display_name": "name",
        "placeholder": "Search school name..",
        "value_field": "id",
        "edit_source_field": "items_details",
        "multiple": true,
        "url": "api/v1/schools/",
        "search_field": "name",
        "edit_display_name": "item_name",
        "res_value_field": "item_config"
      },
      "streams": {
        "type": "field",
        "required": false,
        "read_only": false,
        "label": "Streams"
      }
    }
  }
};
