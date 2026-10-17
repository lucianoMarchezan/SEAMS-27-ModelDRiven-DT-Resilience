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
          "text": "adaptive"
        },
        "specification": {
          "text": "@EventDriven\r\ninterface hm: \r\n    in event component_deviation\r\n    in event defect_activated\r\n    in event fault_exercised\r\n    in event error_propagated\r\n    in event impact_observed\r\n    in event threshold_violated\r\n    in event recovery\r\n    in event health_degraded\r\n    in event health_failed\r\n    in event ideal\r\n    in event erroneous\r\n    \r\n    \r\n\r\ninterface bm:\r\n    in event prepare_for_sos\r\n    in event disengage_from_SoS\r\n    in event join_SoS\r\n    in event leave_SoS\r\n    in event join_constellation\r\n    in event leave_constellation\r\n    in event join_request\r\n    in event join_invitation\r\n    in event admission_rejected\r\n    in event exit_denied\r\n    in event restricted_role\r\n    in event full_role\r\n    in event uncertainty_exceeded\r\n    \r\n    operation announce(): void\r\n    "
        }
      },
      "z": 1
    },
    {
      "position": {
        "x": 1407,
        "y": 159
      },
      "size": {
        "width": 228,
        "height": 801
      },
      "type": "Region",
      "attrs": {
        "priority": {
          "text": 1
        },
        "name": {
          "text": "Health"
        }
      },
      "id": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8",
      "z": 816,
      "embeds": [
        "e39fb634-d8c0-49c4-a4c2-cb13b85c834b",
        "7810ea71-5547-4f7f-bd33-8b241c22ff90",
        "d147c383-b451-41b9-a330-60ee698bab39",
        "64062fe3-7abf-47ea-bb2f-330774399143",
        "23de46c6-dfbf-4456-b56f-768a85d91353",
        "7bd69f8f-71b6-4295-a818-07c29043f594",
        "934d66a3-b78d-411f-9e88-8569f7a888e4",
        "ab68f1ae-6eb0-40b4-8237-0e332d59e5e4",
        "22d93ec4-cb88-485d-a0f5-66cba51eb159",
        "ecbdea8f-5f59-449f-bacd-116ead72f8b9",
        "bb91b722-7f63-4bcf-adf7-5536368aead0",
        "2ef355d0-68e5-4848-abc0-da90e17ddd83",
        "03395e68-3c1e-4da9-ac2a-80b40d5ac154",
        "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "cb845d24-467b-48e6-a2f3-4c1cf84cde0d",
        "7fbcc869-ff6f-4a1b-95c6-4557321d3441",
        "75a455d4-fc36-4986-bfd9-1773d508a43b",
        "9b3acbe5-c224-495c-98eb-835345fb5f9b",
        "bced1833-4cda-4456-89ef-d0879eb4bca3",
        "3275faa1-d7c9-49b0-8f5b-faea819c6117",
        "3d8fdf32-165f-4d38-9a38-5c9785c338d9"
      ]
    },
    {
      "position": {
        "x": 1444,
        "y": 238
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Ideal",
          "fontSize": 11
        }
      },
      "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
      "z": 817,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 1464,
        "y": 179
      },
      "size": {
        "height": 18,
        "width": 18
      },
      "type": "Entry",
      "entryKind": "Initial",
      "attrs": {},
      "id": "cb845d24-467b-48e6-a2f3-4c1cf84cde0d",
      "z": 818,
      "embeds": [
        "4341c1f9-98d2-4a60-807b-5a2287aced3b"
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 1444,
        "y": 342
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
      "id": "7fbcc869-ff6f-4a1b-95c6-4557321d3441",
      "z": 819,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 1444,
        "y": 557
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Erroneous",
          "fontSize": 11
        }
      },
      "id": "75a455d4-fc36-4986-bfd9-1773d508a43b",
      "z": 820,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 1442,
        "y": 445
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
      "id": "9b3acbe5-c224-495c-98eb-835345fb5f9b",
      "z": 821,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 1436,
        "y": 788
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
      "id": "bced1833-4cda-4456-89ef-d0879eb4bca3",
      "z": 822,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 1436,
        "y": 896
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
      "id": "3275faa1-d7c9-49b0-8f5b-faea819c6117",
      "z": 823,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 1425,
        "y": 686
      },
      "size": {
        "height": 60,
        "width": 90
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Malfunctioning",
          "fontSize": 11
        }
      },
      "id": "3d8fdf32-165f-4d38-9a38-5c9785c338d9",
      "z": 824,
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "NodeLabel",
      "label": true,
      "size": {
        "width": 15,
        "height": 15
      },
      "position": {
        "x": 1464,
        "y": 194
      },
      "attrs": {
        "label": {
          "refX": "50%",
          "textAnchor": "middle",
          "refY": "50%",
          "textVerticalAnchor": "middle"
        }
      },
      "id": "4341c1f9-98d2-4a60-807b-5a2287aced3b",
      "z": 838,
      "parent": "cb845d24-467b-48e6-a2f3-4c1cf84cde0d"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "3d8fdf32-165f-4d38-9a38-5c9785c338d9"
      },
      "target": {
        "id": "bced1833-4cda-4456-89ef-d0879eb4bca3",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "45%",
            "dy": "43.333%",
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
              "text": "hm.impact_observed \n/ raise hm.health_degraded"
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
      "id": "64062fe3-7abf-47ea-bb2f-330774399143",
      "z": 839,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "bced1833-4cda-4456-89ef-d0879eb4bca3"
      },
      "target": {
        "id": "3275faa1-d7c9-49b0-8f5b-faea819c6117",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "46.667%",
            "dy": "28.333%",
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
              "text": "hm.threshold_violated\n/ raise hm.health_failed"
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
      "id": "23de46c6-dfbf-4456-b56f-768a85d91353",
      "z": 839,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "9b3acbe5-c224-495c-98eb-835345fb5f9b"
      },
      "target": {
        "id": "75a455d4-fc36-4986-bfd9-1773d508a43b",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "56.667%",
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
          "attrs": {
            "text": {
              "text": "hm.fault_exercised\n/ raise hm.erroneous"
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
      "id": "22d93ec4-cb88-485d-a0f5-66cba51eb159",
      "z": 839,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "75a455d4-fc36-4986-bfd9-1773d508a43b"
      },
      "target": {
        "id": "3d8fdf32-165f-4d38-9a38-5c9785c338d9",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "53.333%",
            "dy": "70%",
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
              "text": "hm.error_propagated"
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
      "id": "d147c383-b451-41b9-a330-60ee698bab39",
      "z": 839,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "7fbcc869-ff6f-4a1b-95c6-4557321d3441"
      },
      "target": {
        "id": "9b3acbe5-c224-495c-98eb-835345fb5f9b",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "46.667%",
            "dy": "30%",
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
              "text": "hm.defect_activated"
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
      "id": "ecbdea8f-5f59-449f-bacd-116ead72f8b9",
      "z": 839,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "3d8fdf32-165f-4d38-9a38-5c9785c338d9"
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "100%",
            "dy": "40%",
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
              "text": "hm.recovery\n/ raise hm.ideal"
            }
          },
          "position": {
            "distance": 0.10340253875546958,
            "offset": 37,
            "angle": 0
          }
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
      "id": "e39fb634-d8c0-49c4-a4c2-cb13b85c834b",
      "z": 839,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 1556,
          "y": 706
        }
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "75a455d4-fc36-4986-bfd9-1773d508a43b"
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "98.333%",
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
          "attrs": {
            "text": {
              "text": "hm.recovery\n/ raise hm.ideal"
            }
          },
          "position": {
            "distance": 0.1499055902136585,
            "offset": 34,
            "angle": 0
          }
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
      "id": "7810ea71-5547-4f7f-bd33-8b241c22ff90",
      "z": 839,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 1558,
          "y": 577
        },
        {
          "x": 1558,
          "y": 263
        }
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "cb845d24-467b-48e6-a2f3-4c1cf84cde0d"
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "51.667%",
            "dy": "28.333%",
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
      "id": "03395e68-3c1e-4da9-ac2a-80b40d5ac154",
      "z": 839,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "7fbcc869-ff6f-4a1b-95c6-4557321d3441",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "93.333%",
            "dy": "60%",
            "rotate": true
          }
        },
        "priority": true
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "70%",
            "dy": "40%",
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
              "text": "hm.recovery\n/ raise hm.ideal"
            }
          },
          "position": {
            "distance": 0.30865266626695453,
            "offset": 34,
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
      "id": "bb91b722-7f63-4bcf-adf7-5536368aead0",
      "z": 839,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 1558,
          "y": 378
        }
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "3275faa1-d7c9-49b0-8f5b-faea819c6117"
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "80%",
            "dy": "43.333%",
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
              "text": "hm.recovery\n/ raise hm.ideal"
            }
          },
          "position": {
            "distance": 0.08656259961408552,
            "offset": 33,
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
      "id": "7bd69f8f-71b6-4295-a818-07c29043f594",
      "z": 839,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 1556,
          "y": 883
        }
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "bced1833-4cda-4456-89ef-d0879eb4bca3"
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "81.667%",
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
          "attrs": {
            "text": {
              "text": "hm.recovery\n/ raise hm.ideal"
            }
          },
          "position": {
            "distance": 0.112173528473951,
            "offset": 39.000000000000114,
            "angle": 0
          }
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
      "id": "934d66a3-b78d-411f-9e88-8569f7a888e4",
      "z": 839,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 1557,
          "y": 796
        }
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "9b3acbe5-c224-495c-98eb-835345fb5f9b"
      },
      "target": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "73.333%",
            "dy": "43.333%",
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
              "text": "hm.recovery\n/ raise hm.ideal"
            }
          },
          "position": {
            "distance": 0.21989833894281105,
            "offset": 35,
            "angle": 0
          }
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
      "id": "ab68f1ae-6eb0-40b4-8237-0e332d59e5e4",
      "z": 839,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 1558,
          "y": 465
        }
      ],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "d7cec1ec-c4e9-435e-9cef-9c08838c88f4"
      },
      "target": {
        "id": "7fbcc869-ff6f-4a1b-95c6-4557321d3441",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "51.667%",
            "dy": "26.667%",
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
              "text": "hm.component_deviation"
            }
          },
          "position": {
            "distance": 0.45454545454545453,
            "offset": -2,
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
      "id": "2ef355d0-68e5-4848-abc0-da90e17ddd83",
      "z": 839,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "54ec5ffe-3699-43d9-851d-40ed32b1e2d8"
    },
    {
      "position": {
        "x": 1668,
        "y": 178
      },
      "size": {
        "width": 973,
        "height": 770
      },
      "type": "Region",
      "attrs": {
        "priority": {
          "text": 2
        },
        "name": {
          "text": "Belonging"
        }
      },
      "id": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa",
      "z": 1128,
      "embeds": [
        "dd09b617-7268-412c-8d07-1ec1e86972fe",
        "b20692d2-5543-4648-b5e1-c2ebf4450cfe",
        "74b1041b-063b-49fb-a126-edab4b2d3283",
        "23b485c9-1baa-4833-a244-afd80bebe8ac",
        "f49fc90b-8d64-496d-8bef-3efa119e6073",
        "1a7e9eff-03d7-4795-a84a-49408b263274",
        "fb040fcf-ab7e-4a04-9bd0-ea333a9c52ba",
        "d66319eb-cbb3-4f17-939b-a4c3525e341c",
        "8bb05136-92fc-494a-9ed6-1b29a8a92ee8",
        "98c7e231-e9d8-4805-b1a9-0da3d19033b9",
        "278c7643-e1f6-44c2-b2a0-c83c48786346",
        "f1299df2-e8b4-43cd-8106-91793cbf98d4",
        "8ab39783-777b-45cc-9f81-8d6cb1cc294f",
        "1ef82dc2-0c68-4514-802f-73db7eb4e558",
        "7b1028f0-5c3f-4ffe-a67e-35c439651036"
      ]
    },
    {
      "position": {
        "x": 2203,
        "y": 268
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Prepared",
          "fontSize": 11
        }
      },
      "id": "278c7643-e1f6-44c2-b2a0-c83c48786346",
      "z": 1129,
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "position": {
        "x": 1685,
        "y": 395
      },
      "size": {
        "height": 550,
        "width": 513
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Active",
          "fontSize": 11
        }
      },
      "id": "f1299df2-e8b4-43cd-8106-91793cbf98d4",
      "z": 1130,
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa",
      "embeds": [
        "6a961907-2f8a-415b-aff0-38da579dd9f0"
      ]
    },
    {
      "position": {
        "x": 1845,
        "y": 268
      },
      "size": {
        "height": 60,
        "width": 69
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Disengaged",
          "fontSize": 11
        }
      },
      "id": "8ab39783-777b-45cc-9f81-8d6cb1cc294f",
      "z": 1131,
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "position": {
        "x": 1688,
        "y": 440
      },
      "size": {
        "width": 507,
        "height": 502
      },
      "type": "Region",
      "attrs": {
        "priority": {
          "text": 1
        },
        "name": {
          "text": "Active Region"
        }
      },
      "id": "6a961907-2f8a-415b-aff0-38da579dd9f0",
      "z": 1131,
      "embeds": [
        "f60283c2-3bdf-4fb0-b62e-1ea76ca5f248",
        "839e7f01-aa64-471f-8031-a6cdeb7276f3",
        "1cd163dd-8fda-4627-a25c-88d46367620d",
        "1a7e9eff-03d7-4795-a84a-49408b263274",
        "dfc4d6cf-ac79-45c1-b9c8-2a7b249f01d6",
        "b37d720f-11c3-4973-9eaa-6ca2569f636c",
        "963f0b59-6aae-4862-9c33-1b4e158e13b2",
        "83825638-1d05-496c-a71c-6f88e830501b",
        "2e4b25b6-392d-4fef-93a7-514643a6be9b",
        "070579d7-38d0-49e0-b07b-c9f7e836c1ca",
        "a9d6f60b-2b13-4e20-bcff-bec7f929c0c4",
        "6d205a79-a2fe-46a7-854d-45e63d9c9fbc"
      ],
      "parent": "f1299df2-e8b4-43cd-8106-91793cbf98d4"
    },
    {
      "position": {
        "x": 1864,
        "y": 206
      },
      "size": {
        "height": 18,
        "width": 18
      },
      "type": "Entry",
      "entryKind": "Initial",
      "attrs": {},
      "id": "1ef82dc2-0c68-4514-802f-73db7eb4e558",
      "z": 1132,
      "embeds": [
        "294dab23-93ec-4d81-91cd-2b37d6d5c8f2"
      ],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "070579d7-38d0-49e0-b07b-c9f7e836c1ca",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "88.148%",
            "dy": "99.163%",
            "rotate": true
          }
        },
        "priority": true
      },
      "target": {
        "id": "6d205a79-a2fe-46a7-854d-45e63d9c9fbc",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "96.842%",
            "dy": "16.129%",
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
              "text": "bm.leave_constellation\n/ bm.announce"
            }
          },
          "position": {
            "distance": 0.3144199187123448,
            "offset": -27.7431640625,
            "angle": 0
          }
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
      "id": "839e7f01-aa64-471f-8031-a6cdeb7276f3",
      "z": 1132,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 2049,
          "y": 872
        }
      ],
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "6d205a79-a2fe-46a7-854d-45e63d9c9fbc",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "1.053%",
            "dy": "24.194%",
            "rotate": true
          }
        },
        "priority": true
      },
      "target": {
        "id": "070579d7-38d0-49e0-b07b-c9f7e836c1ca",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "12.963%",
            "dy": "99.163%",
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
              "text": "bm.exit_denied"
            }
          },
          "position": {
            "distance": 0.16911064443079327,
            "offset": 26.2498779296875,
            "angle": 0
          }
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
      "id": "1cd163dd-8fda-4627-a25c-88d46367620d",
      "z": 1133,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 1867,
          "y": 877
        }
      ],
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "0b1205f9-bac5-4173-8267-b891da3e54a9"
      },
      "target": {
        "id": "6d205a79-a2fe-46a7-854d-45e63d9c9fbc",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "26.316%",
            "dy": "24.194%",
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
              "text": "bm.uncertainty_exceeded\n/bm.announce"
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
      "id": "1a7e9eff-03d7-4795-a84a-49408b263274",
      "z": 1134,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "2e4b25b6-392d-4fef-93a7-514643a6be9b"
      },
      "target": {
        "id": "070579d7-38d0-49e0-b07b-c9f7e836c1ca",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "53.125%",
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
          "attrs": {
            "text": {
              "text": "after 3s"
            }
          },
          "position": {
            "offset": -27,
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
      "id": "dfc4d6cf-ac79-45c1-b9c8-2a7b249f01d6",
      "z": 1135,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "070579d7-38d0-49e0-b07b-c9f7e836c1ca"
      },
      "target": {
        "id": "6d205a79-a2fe-46a7-854d-45e63d9c9fbc",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "46.316%",
            "dy": "38.71%",
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
              "text": "hm.health_degraded\n/ bm.announce"
            }
          },
          "position": {
            "distance": 0.24207689803186747,
            "offset": 47,
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
      "id": "b37d720f-11c3-4973-9eaa-6ca2569f636c",
      "z": 1136,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 1834,
          "y": 886
        }
      ],
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "2e4b25b6-392d-4fef-93a7-514643a6be9b"
      },
      "target": {
        "id": "6d205a79-a2fe-46a7-854d-45e63d9c9fbc",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "22.105%",
            "dy": "67.742%",
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
              "text": "bm.leave_constellation\n/ bm.announce"
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
      "id": "963f0b59-6aae-4862-9c33-1b4e158e13b2",
      "z": 1137,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 1857,
          "y": 513
        },
        {
          "x": 1729,
          "y": 725
        }
      ],
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "a9d6f60b-2b13-4e20-bcff-bec7f929c0c4"
      },
      "target": {
        "id": "2e4b25b6-392d-4fef-93a7-514643a6be9b",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "97.872%",
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
      "id": "83825638-1d05-496c-a71c-6f88e830501b",
      "z": 1138,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "position": {
        "x": 1895,
        "y": 474
      },
      "size": {
        "height": 60,
        "width": 94
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "PendingEntry",
          "fontSize": 11
        }
      },
      "id": "2e4b25b6-392d-4fef-93a7-514643a6be9b",
      "z": 1139,
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "position": {
        "x": 1811,
        "y": 588
      },
      "size": {
        "height": 239,
        "width": 270
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Participating",
          "fontSize": 11
        }
      },
      "id": "070579d7-38d0-49e0-b07b-c9f7e836c1ca",
      "z": 1140,
      "embeds": [
        "00c2a341-3390-473a-88f5-df39262afeac"
      ],
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "position": {
        "x": 1814,
        "y": 633
      },
      "size": {
        "width": 264,
        "height": 191
      },
      "type": "Region",
      "attrs": {
        "priority": {
          "text": 1
        }
      },
      "id": "00c2a341-3390-473a-88f5-df39262afeac",
      "z": 1141,
      "embeds": [
        "83277cc3-7fb2-43e4-b9be-5388b108ec4b",
        "cae2cf59-588b-47e3-bbf1-f7a06c2147a0",
        "b234e24e-bbc6-4931-a221-8239974765f9",
        "2db95d83-251d-466b-9247-c7c7f6b0fdbc",
        "affb0338-3aff-4d59-9a46-8212284b903e",
        "e4025a63-7023-4406-be60-de35fba2ae1f",
        "55e58da3-c58d-4f33-85f4-cc44dbd46501",
        "bd31f463-3baf-4873-81c5-5b118dfb88f7",
        "0b1205f9-bac5-4173-8267-b891da3e54a9"
      ],
      "parent": "070579d7-38d0-49e0-b07b-c9f7e836c1ca"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "e4025a63-7023-4406-be60-de35fba2ae1f"
      },
      "target": {
        "id": "0b1205f9-bac5-4173-8267-b891da3e54a9",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "38.542%",
            "dy": "8.333%",
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
              "text": "hm.erroneous"
            }
          },
          "position": {
            "distance": 0.5116279069767442,
            "offset": 47,
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
      "id": "83277cc3-7fb2-43e4-b9be-5388b108ec4b",
      "z": 1142,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "00c2a341-3390-473a-88f5-df39262afeac"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "bd31f463-3baf-4873-81c5-5b118dfb88f7"
      },
      "target": {
        "id": "0b1205f9-bac5-4173-8267-b891da3e54a9",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "81.25%",
            "dy": "70%",
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
              "text": "[active(Health.Erroneous) \n|| active(Health.Malfunctioning)]"
            }
          },
          "position": {
            "distance": 0.49445879481907096,
            "offset": -94.91429506742611,
            "angle": 0
          }
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
      "id": "cae2cf59-588b-47e3-bbf1-f7a06c2147a0",
      "z": 1143,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 1997.5,
          "y": 782
        }
      ],
      "parent": "00c2a341-3390-473a-88f5-df39262afeac"
    },
    {
      "type": "NodeLabel",
      "label": true,
      "size": {
        "width": 15,
        "height": 15
      },
      "position": {
        "x": 1864,
        "y": 221
      },
      "attrs": {
        "label": {
          "refX": "50%",
          "textAnchor": "middle",
          "refY": "50%",
          "textVerticalAnchor": "middle"
        }
      },
      "id": "294dab23-93ec-4d81-91cd-2b37d6d5c8f2",
      "z": 1144,
      "parent": "1ef82dc2-0c68-4514-802f-73db7eb4e558"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "0b1205f9-bac5-4173-8267-b891da3e54a9"
      },
      "target": {
        "id": "e4025a63-7023-4406-be60-de35fba2ae1f",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "73.333%",
            "dy": "71.667%",
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
              "text": "hm.ideal"
            }
          },
          "position": {
            "distance": 0.1342703262451422,
            "offset": 23.000000000000227,
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
      "id": "b234e24e-bbc6-4931-a221-8239974765f9",
      "z": 1144,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 1927,
          "y": 696
        }
      ],
      "parent": "00c2a341-3390-473a-88f5-df39262afeac"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "55e58da3-c58d-4f33-85f4-cc44dbd46501"
      },
      "target": {
        "id": "bd31f463-3baf-4873-81c5-5b118dfb88f7"
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
      "id": "2db95d83-251d-466b-9247-c7c7f6b0fdbc",
      "z": 1145,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "00c2a341-3390-473a-88f5-df39262afeac"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "bd31f463-3baf-4873-81c5-5b118dfb88f7"
      },
      "target": {
        "id": "e4025a63-7023-4406-be60-de35fba2ae1f",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "76.667%",
            "dy": "45%",
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
              "text": "else"
            }
          },
          "position": {
            "distance": 0.31155778894472363,
            "offset": 16,
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
      "id": "affb0338-3aff-4d59-9a46-8212284b903e",
      "z": 1146,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "00c2a341-3390-473a-88f5-df39262afeac"
    },
    {
      "position": {
        "x": 1833,
        "y": 653
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "FullRole",
          "fontSize": 11
        }
      },
      "id": "e4025a63-7023-4406-be60-de35fba2ae1f",
      "z": 1147,
      "parent": "00c2a341-3390-473a-88f5-df39262afeac"
    },
    {
      "position": {
        "x": 2049,
        "y": 676
      },
      "size": {
        "height": 18,
        "width": 18
      },
      "type": "Entry",
      "entryKind": "Initial",
      "attrs": {},
      "id": "55e58da3-c58d-4f33-85f4-cc44dbd46501",
      "z": 1148,
      "embeds": [
        "d584e3c1-85a5-45ff-ac09-a55d3a4eb3e0"
      ],
      "parent": "00c2a341-3390-473a-88f5-df39262afeac"
    },
    {
      "type": "NodeLabel",
      "label": true,
      "size": {
        "width": 15,
        "height": 15
      },
      "position": {
        "x": 2049,
        "y": 691
      },
      "attrs": {
        "label": {
          "refX": "50%",
          "textAnchor": "middle",
          "refY": "50%",
          "textVerticalAnchor": "middle"
        }
      },
      "id": "d584e3c1-85a5-45ff-ac09-a55d3a4eb3e0",
      "z": 1149,
      "parent": "55e58da3-c58d-4f33-85f4-cc44dbd46501"
    },
    {
      "position": {
        "x": 1990,
        "y": 675
      },
      "size": {
        "width": 15,
        "height": 15
      },
      "type": "Choice",
      "attrs": {},
      "id": "bd31f463-3baf-4873-81c5-5b118dfb88f7",
      "z": 1150,
      "parent": "00c2a341-3390-473a-88f5-df39262afeac"
    },
    {
      "position": {
        "x": 1833,
        "y": 756
      },
      "size": {
        "height": 60,
        "width": 96
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "RestrictedRole",
          "fontSize": 11
        }
      },
      "id": "0b1205f9-bac5-4173-8267-b891da3e54a9",
      "z": 1151,
      "parent": "00c2a341-3390-473a-88f5-df39262afeac"
    },
    {
      "position": {
        "x": 2045,
        "y": 490
      },
      "size": {
        "height": 18,
        "width": 18
      },
      "type": "Entry",
      "entryKind": "Initial",
      "attrs": {},
      "id": "a9d6f60b-2b13-4e20-bcff-bec7f929c0c4",
      "z": 1152,
      "embeds": [
        "de6aed02-9868-46b9-aab8-648dd88df4b7"
      ],
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "type": "NodeLabel",
      "label": true,
      "size": {
        "width": 15,
        "height": 15
      },
      "position": {
        "x": 2045,
        "y": 505
      },
      "attrs": {
        "label": {
          "refX": "50%",
          "textAnchor": "middle",
          "refY": "50%",
          "textVerticalAnchor": "middle"
        }
      },
      "id": "de6aed02-9868-46b9-aab8-648dd88df4b7",
      "z": 1153,
      "parent": "a9d6f60b-2b13-4e20-bcff-bec7f929c0c4"
    },
    {
      "position": {
        "x": 1903,
        "y": 862
      },
      "size": {
        "height": 62,
        "width": 95
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "PendingExit",
          "fontSize": 11
        }
      },
      "id": "6d205a79-a2fe-46a7-854d-45e63d9c9fbc",
      "z": 1154,
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "1ef82dc2-0c68-4514-802f-73db7eb4e558"
      },
      "target": {
        "id": "8ab39783-777b-45cc-9f81-8d6cb1cc294f",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "40.708%",
            "dy": "32.836%",
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
      "id": "d66319eb-cbb3-4f17-939b-a4c3525e341c",
      "z": 1164,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "f1299df2-e8b4-43cd-8106-91793cbf98d4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "100%",
            "dy": "9.893%",
            "rotate": true
          }
        },
        "priority": true
      },
      "target": {
        "id": "278c7643-e1f6-44c2-b2a0-c83c48786346",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "36.667%",
            "dy": "71.667%",
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
              "text": "hm.health_failed\n/bm.announce"
            }
          },
          "position": {
            "distance": 0.28030539571045454,
            "offset": -47.62080078124986,
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
      "id": "fb040fcf-ab7e-4a04-9bd0-ea333a9c52ba",
      "z": 1164,
      "router": {
        "name": "normal"
      },
      "vertices": [
        {
          "x": 2145,
          "y": 384
        }
      ],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "8ab39783-777b-45cc-9f81-8d6cb1cc294f"
      },
      "target": {
        "id": "278c7643-e1f6-44c2-b2a0-c83c48786346",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "16.667%",
            "dy": "26.667%",
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
              "text": "bm.prepare_for_sos"
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
      "id": "98c7e231-e9d8-4805-b1a9-0da3d19033b9",
      "z": 1164,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "278c7643-e1f6-44c2-b2a0-c83c48786346"
      },
      "target": {
        "id": "8ab39783-777b-45cc-9f81-8d6cb1cc294f",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "63.8%",
            "dy": "78.333%",
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
              "text": "bm.disengage_from_SoS"
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
      "id": "8bb05136-92fc-494a-9ed6-1b29a8a92ee8",
      "z": 1164,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "position": {
        "x": 2253,
        "y": 481
      },
      "size": {
        "height": 358,
        "width": 289
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Passive",
          "fontSize": 11
        }
      },
      "id": "7b1028f0-5c3f-4ffe-a67e-35c439651036",
      "z": 1209,
      "embeds": [
        "2d655f6e-05b5-4fb8-b0cb-3245e9785c1b"
      ],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "position": {
        "x": 2256,
        "y": 526
      },
      "size": {
        "width": 283,
        "height": 310
      },
      "type": "Region",
      "attrs": {
        "priority": {
          "text": 1
        }
      },
      "id": "2d655f6e-05b5-4fb8-b0cb-3245e9785c1b",
      "z": 1210,
      "embeds": [
        "878d261c-7dca-4e7a-91b6-8f390519571a",
        "8a864455-d845-44c9-b903-e2e37e635e0b",
        "9828e764-c818-40ff-a9cd-7138f71152ea",
        "bad32f1a-8cca-466c-9129-dae9f30b1342",
        "c0b354bf-7c54-4130-a94a-3f5fe19fe2fd",
        "2f017e8e-3e1d-45ef-ab38-5a3c1dcf6a8c",
        "7fcc163d-062f-4222-bb17-b4fe1b36f4a6"
      ],
      "parent": "7b1028f0-5c3f-4ffe-a67e-35c439651036"
    },
    {
      "position": {
        "x": 2394,
        "y": 553
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Available",
          "fontSize": 11
        }
      },
      "id": "c0b354bf-7c54-4130-a94a-3f5fe19fe2fd",
      "z": 1211,
      "parent": "2d655f6e-05b5-4fb8-b0cb-3245e9785c1b"
    },
    {
      "position": {
        "x": 2509,
        "y": 571
      },
      "size": {
        "height": 18,
        "width": 18
      },
      "type": "Entry",
      "entryKind": "Initial",
      "attrs": {},
      "id": "2f017e8e-3e1d-45ef-ab38-5a3c1dcf6a8c",
      "z": 1212,
      "embeds": [
        "c84267b3-a1f9-44f1-b84c-26f7e7f80ee6"
      ],
      "parent": "2d655f6e-05b5-4fb8-b0cb-3245e9785c1b"
    },
    {
      "position": {
        "x": 2383,
        "y": 723
      },
      "size": {
        "height": 60,
        "width": 89
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Negotiating",
          "fontSize": 11
        }
      },
      "id": "7fcc163d-062f-4222-bb17-b4fe1b36f4a6",
      "z": 1213,
      "embeds": [],
      "parent": "2d655f6e-05b5-4fb8-b0cb-3245e9785c1b"
    },
    {
      "type": "NodeLabel",
      "label": true,
      "size": {
        "width": 15,
        "height": 15
      },
      "position": {
        "x": 2509,
        "y": 586
      },
      "attrs": {
        "label": {
          "refX": "50%",
          "textAnchor": "middle",
          "refY": "50%",
          "textVerticalAnchor": "middle"
        }
      },
      "id": "c84267b3-a1f9-44f1-b84c-26f7e7f80ee6",
      "z": 1218,
      "parent": "2f017e8e-3e1d-45ef-ab38-5a3c1dcf6a8c"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "7fcc163d-062f-4222-bb17-b4fe1b36f4a6",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "12.36%",
            "dy": "78.333%",
            "rotate": true
          }
        },
        "priority": true
      },
      "target": {
        "id": "f1299df2-e8b4-43cd-8106-91793cbf98d4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "99.174%",
            "dy": "58.684%",
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
              "text": "bm.join_constellation\n/ bm.announce"
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
      "id": "dd09b617-7268-412c-8d07-1ec1e86972fe",
      "z": 1219,
      "router": {
        "name": "normal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "2f017e8e-3e1d-45ef-ab38-5a3c1dcf6a8c"
      },
      "target": {
        "id": "c0b354bf-7c54-4130-a94a-3f5fe19fe2fd",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "75%",
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
      "id": "bad32f1a-8cca-466c-9129-dae9f30b1342",
      "z": 1219,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "2d655f6e-05b5-4fb8-b0cb-3245e9785c1b"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "7fcc163d-062f-4222-bb17-b4fe1b36f4a6",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "89.888%",
            "dy": "55%",
            "rotate": true
          }
        },
        "priority": true
      },
      "target": {
        "id": "c0b354bf-7c54-4130-a94a-3f5fe19fe2fd",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "98.333%",
            "dy": "78.333%",
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
              "text": "bm.admission_rejected"
            }
          },
          "position": {
            "distance": 0.5430179224684075,
            "offset": 9,
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
      "id": "9828e764-c818-40ff-a9cd-7138f71152ea",
      "z": 1219,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 2505,
          "y": 728
        },
        {
          "x": 2505,
          "y": 640
        }
      ],
      "parent": "2d655f6e-05b5-4fb8-b0cb-3245e9785c1b"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "c0b354bf-7c54-4130-a94a-3f5fe19fe2fd",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "18.333%",
            "dy": "31.667%",
            "rotate": true
          }
        },
        "priority": true
      },
      "target": {
        "id": "7fcc163d-062f-4222-bb17-b4fe1b36f4a6",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "1.124%",
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
          "attrs": {
            "text": {
              "text": "bm.join_request \n[active(Health.Ideal)]"
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
      "id": "8a864455-d845-44c9-b903-e2e37e635e0b",
      "z": 1219,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 2361,
          "y": 611
        }
      ],
      "parent": "2d655f6e-05b5-4fb8-b0cb-3245e9785c1b"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "c0b354bf-7c54-4130-a94a-3f5fe19fe2fd"
      },
      "target": {
        "id": "7fcc163d-062f-4222-bb17-b4fe1b36f4a6",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "68.539%",
            "dy": "5%",
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
              "text": "bm.join_invitation \n[!active(Health.Ideal)]"
            }
          },
          "position": {
            "distance": 0.7902748801491477,
            "offset": 7,
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
      "id": "878d261c-7dca-4e7a-91b6-8f390519571a",
      "z": 1219,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "2d655f6e-05b5-4fb8-b0cb-3245e9785c1b"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "6d205a79-a2fe-46a7-854d-45e63d9c9fbc"
      },
      "target": {
        "id": "7b1028f0-5c3f-4ffe-a67e-35c439651036",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "0.926%",
            "dy": "92.012%",
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
              "text": "after 3s\n/bm.announce"
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
      "id": "b20692d2-5543-4648-b5e1-c2ebf4450cfe",
      "z": 1219,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "278c7643-e1f6-44c2-b2a0-c83c48786346"
      },
      "target": {
        "id": "7b1028f0-5c3f-4ffe-a67e-35c439651036",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "85%",
            "dy": "3.333%",
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
              "text": "bm.join_SoS \n[!active(Health.Failed)]\n/ bm.announce"
            }
          },
          "position": {
            "distance": 0.6081081081081081,
            "offset": -69,
            "angle": 0
          }
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
      "id": "74b1041b-063b-49fb-a126-edab4b2d3283",
      "z": 1219,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "7b1028f0-5c3f-4ffe-a67e-35c439651036"
      },
      "target": {
        "id": "278c7643-e1f6-44c2-b2a0-c83c48786346",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "78.333%",
            "dy": "53.333%",
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
              "text": "hm.health_failed\n/bm.announce"
            }
          },
          "position": {
            "distance": 0.18044979047711585,
            "offset": 14.5,
            "angle": 0
          }
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
      "id": "23b485c9-1baa-4833-a244-afd80bebe8ac",
      "z": 1219,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 2391,
          "y": 446
        }
      ],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "7b1028f0-5c3f-4ffe-a67e-35c439651036"
      },
      "target": {
        "id": "278c7643-e1f6-44c2-b2a0-c83c48786346",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "10%",
            "dy": "95%",
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
              "text": "bm.leave_SoS\n/ bm.announce"
            }
          },
          "position": {
            "distance": 0.4864864864864865,
            "offset": 0,
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
      "id": "f49fc90b-8d64-496d-8bef-3efa119e6073",
      "z": 1219,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "bd31f463-3baf-4873-81c5-5b118dfb88f7"
      },
      "target": {
        "id": "6d205a79-a2fe-46a7-854d-45e63d9c9fbc",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "91.579%",
            "dy": "6.452%",
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
              "text": "[active(Health.Degraded) \n|| active(Health.Faulty)]\n/ bm.announce"
            }
          },
          "position": {
            "distance": 0.7674990486896734,
            "offset": -36,
            "angle": 0
          }
        },
        {
          "attrs": {
            "label": {
              "text": "3"
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
      "id": "f60283c2-3bdf-4fb0-b62e-1ea76ca5f248",
      "z": 1220,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    }
  ]
}