{
  "cells": [
    {
      "position": {
        "x": 0,
        "y": 0
      },
      "size": {
        "height": 10,
        "width": 10
      },
      "type": "Statechart",
      "id": "78749915-0da0-40a2-862f-9e8d94c7c68e",
      "attrs": {
        "name": {
          "text": "health"
        },
        "specification": {
          "text": "@EventDriven\n@SuperSteps(no)\n\ninterface: \n    in event component_deviation\n    in event defect_activated\n    in event fault_exercised\n    in event error_propagated\n    in event impact_observed\n    in event threshold_violated\n    in event recovery\n"
        }
      },
      "z": 1
    },
    {
      "position": {
        "x": 222.5,
        "y": 130
      },
      "size": {
        "height": 15,
        "width": 15
      },
      "type": "Entry",
      "entryKind": "Entry",
      "attrs": {},
      "id": "a4d257fe-72cb-4334-9a1f-b5a8b4f886fb",
      "z": 2,
      "embeds": [
        "f70f632c-e54d-4002-9ec5-7baec620de10"
      ]
    },
    {
      "type": "NodeLabel",
      "label": true,
      "size": {
        "width": 15,
        "height": 15
      },
      "position": {
        "x": 222.5,
        "y": 145
      },
      "attrs": {
        "label": {
          "refX": "50%",
          "textAnchor": "middle",
          "refY": "50%",
          "textVerticalAnchor": "middle"
        }
      },
      "id": "f70f632c-e54d-4002-9ec5-7baec620de10",
      "z": 3,
      "parent": "a4d257fe-72cb-4334-9a1f-b5a8b4f886fb"
    },
    {
      "position": {
        "x": 200,
        "y": 200
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Initial",
          "fontSize": 11
        }
      },
      "id": "36b8548a-74b1-4925-ae23-291c03231ee6",
      "z": 4
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "a4d257fe-72cb-4334-9a1f-b5a8b4f886fb"
      },
      "target": {
        "id": "36b8548a-74b1-4925-ae23-291c03231ee6"
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {},
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "router": {
        "name": "orthogonal",
        "args": {
          "padding": 8
        }
      },
      "id": "9b5ce41b-0116-46a8-a603-ea4119c6e5d7",
      "z": 6
    },
    {
      "position": {
        "x": 198,
        "y": 314
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Defective",
          "fontSize": 11
        }
      },
      "id": "ffb0d71b-c939-4854-a070-7d1a1becae64",
      "z": 9
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "36b8548a-74b1-4925-ae23-291c03231ee6"
      },
      "target": {
        "id": "ffb0d71b-c939-4854-a070-7d1a1becae64",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "55%",
            "dy": "48.333%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "component_deviation"
            }
          },
          "position": {
            "distance": 0.5555555555555556,
            "offset": 45,
            "angle": 0
          }
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "c6f5794d-4899-4a68-95bd-d22bf8243d46",
      "z": 10,
      "router": {
        "name": "orthogonal"
      },
      "vertices": []
    },
    {
      "position": {
        "x": 201,
        "y": 421
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Faulty",
          "fontSize": 11
        }
      },
      "id": "46dd633b-5813-4672-96ea-cfa7860aaec3",
      "z": 17
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "ffb0d71b-c939-4854-a070-7d1a1becae64"
      },
      "target": {
        "id": "46dd633b-5813-4672-96ea-cfa7860aaec3",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "51.667%",
            "dy": "63.333%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "defect_activated"
            }
          },
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "61aab15a-0864-4467-85c4-a9f5e35c7e1d",
      "z": 18,
      "router": {
        "name": "orthogonal"
      },
      "vertices": []
    },
    {
      "position": {
        "x": 201,
        "y": 524
      },
      "size": {
        "width": -1,
        "height": -1
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Erroneous",
          "fontSize": 11
        }
      },
      "id": "84179ccb-aad2-453b-a539-68c5ec3ab62c",
      "z": 23
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "46dd633b-5813-4672-96ea-cfa7860aaec3"
      },
      "target": {
        "id": "84179ccb-aad2-453b-a539-68c5ec3ab62c",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "50%",
            "dy": "51.667%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "fault_exercised"
            }
          },
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "459b64fe-c081-4211-ae67-d4e6662c3b45",
      "z": 24,
      "router": {
        "name": "orthogonal"
      },
      "vertices": []
    },
    {
      "position": {
        "x": 182,
        "y": 642
      },
      "size": {
        "width": 102,
        "height": 69
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Malfunctioning",
          "fontSize": 11
        }
      },
      "id": "60e9a470-1b56-4d74-be3a-91151432623c",
      "z": 27
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "84179ccb-aad2-453b-a539-68c5ec3ab62c"
      },
      "target": {
        "id": "60e9a470-1b56-4d74-be3a-91151432623c",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "49.02%",
            "dy": "47.826%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "error_propagated"
            }
          },
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "d080dae6-eb18-4141-abba-09f43813839c",
      "z": 28,
      "router": {
        "name": "orthogonal"
      },
      "vertices": []
    },
    {
      "position": {
        "x": 198,
        "y": 769
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Degraded",
          "fontSize": 11
        }
      },
      "id": "b990bdb0-0927-4f8f-aa3e-40d835facd72",
      "z": 31
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "60e9a470-1b56-4d74-be3a-91151432623c"
      },
      "target": {
        "id": "b990bdb0-0927-4f8f-aa3e-40d835facd72",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "56.667%",
            "dy": "51.667%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {},
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "6394b73e-6cfd-47d5-9a58-6596b0a8aa78",
      "z": 32,
      "router": {
        "name": "orthogonal"
      },
      "vertices": []
    },
    {
      "position": {
        "x": 200,
        "y": 879
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Failed",
          "fontSize": 11
        }
      },
      "id": "3fc69999-c6f2-4444-8085-97a96fa796de",
      "z": 35
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "b990bdb0-0927-4f8f-aa3e-40d835facd72"
      },
      "target": {
        "id": "3fc69999-c6f2-4444-8085-97a96fa796de",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "53.333%",
            "dy": "75%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {},
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "c0f96b25-579f-48f8-b7ee-fe9090775f17",
      "z": 36,
      "router": {
        "name": "orthogonal"
      },
      "vertices": []
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "ffb0d71b-c939-4854-a070-7d1a1becae64",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "56.667%",
            "dy": "71.667%",
            "rotate": true
          }
        },
        "priority": true
      },
      "target": {
        "id": "36b8548a-74b1-4925-ae23-291c03231ee6",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "93.333%",
            "dy": "46.667%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {
            "text": {
              "text": "recovery"
            }
          },
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "2"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "f81280e7-9329-4752-9fa5-19341993b530",
      "z": 37,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 285,
          "y": 329
        }
      ]
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "46dd633b-5813-4672-96ea-cfa7860aaec3"
      },
      "target": {
        "id": "36b8548a-74b1-4925-ae23-291c03231ee6",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "91.667%",
            "dy": "41.667%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {},
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "2"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "e73f84b6-a765-462b-a485-984309298b0e",
      "z": 38,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 286,
          "y": 443
        }
      ]
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "84179ccb-aad2-453b-a539-68c5ec3ab62c"
      },
      "target": {
        "id": "36b8548a-74b1-4925-ae23-291c03231ee6",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "68.333%",
            "dy": "55%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {},
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "2"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "ef5d0326-ceb2-46ab-bef2-c3a5468e8949",
      "z": 39,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 285,
          "y": 545
        }
      ]
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "60e9a470-1b56-4d74-be3a-91151432623c"
      },
      "target": {
        "id": "36b8548a-74b1-4925-ae23-291c03231ee6",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "58.333%",
            "dy": "66.667%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {},
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "2"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "7cb67df1-e2be-40eb-ac21-acb11df84c3a",
      "z": 40,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 310,
          "y": 663
        }
      ]
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "b990bdb0-0927-4f8f-aa3e-40d835facd72"
      },
      "target": {
        "id": "36b8548a-74b1-4925-ae23-291c03231ee6",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "83.333%",
            "dy": "48.333%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {},
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "2"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "30d208ac-c57b-4736-8fcd-fed27a102bb5",
      "z": 41,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 310,
          "y": 790
        }
      ]
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "3fc69999-c6f2-4444-8085-97a96fa796de"
      },
      "target": {
        "id": "36b8548a-74b1-4925-ae23-291c03231ee6",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "56.667%",
            "dy": "35%",
            "rotate": true
          }
        },
        "priority": true
      },
      "connector": {
        "name": "rounded"
      },
      "labels": [
        {
          "attrs": {},
          "position": {}
        },
        {
          "attrs": {
            "label": {
              "text": "1"
            }
          }
        },
        {
          "attrs": {}
        },
        {
          "attrs": {}
        }
      ],
      "id": "2bcd1110-8e89-4c05-8d8a-87351a2d7375",
      "z": 42,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 308,
          "y": 904
        }
      ]
    }
  ]
}