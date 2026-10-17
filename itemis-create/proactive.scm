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
          "text": "proactive"
        },
        "specification": {
          "text": "@EventDriven\r\ninterface hm: \r\n    in event component_deviation\r\n    in event defect_activated\r\n    in event fault_exercised\r\n    in event error_propagated\r\n    in event impact_observed\r\n    in event threshold_violated\r\n    in event recovery\r\n    in event health_failed\r\n    \r\n    \r\n\r\ninterface bm:\r\n    in event prepare_for_sos\r\n    in event disengage_from_SoS\r\n    in event join_SoS\r\n    in event leave_SoS\r\n    in event join_constellation\r\n    in event leave_constellation\r\n    \r\n    operation announce(): void\r\n    "
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
              "text": "hm.impact_observed"
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
              "text": "hm.fault_exercised"
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
              "text": "hm.recovery"
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
              "text": "hm.recovery"
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
              "text": "hm.recovery"
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
              "text": "hm.recovery"
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
              "text": "hm.recovery"
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
              "text": "hm.recovery"
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
        "x": 1666,
        "y": 162
      },
      "size": {
        "width": 578,
        "height": 631
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
      "z": 1094,
      "embeds": [
        "74b1041b-063b-49fb-a126-edab4b2d3283",
        "2cd42d87-7f66-403b-bb1f-61e024c03b25",
        "23b485c9-1baa-4833-a244-afd80bebe8ac",
        "fb040fcf-ab7e-4a04-9bd0-ea333a9c52ba",
        "f594dd83-a7dc-444a-8df9-74f1d5852113",
        "f49fc90b-8d64-496d-8bef-3efa119e6073",
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
        "x": 2039,
        "y": 252
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
      "z": 1095,
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "position": {
        "x": 1675,
        "y": 379
      },
      "size": {
        "height": 380,
        "width": 242
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Active",
          "fontSize": 11
        }
      },
      "id": "f1299df2-e8b4-43cd-8106-91793cbf98d4",
      "z": 1096,
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa",
      "embeds": [
        "6a961907-2f8a-415b-aff0-38da579dd9f0"
      ]
    },
    {
      "position": {
        "x": 1681,
        "y": 252
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
      "z": 1097,
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "position": {
        "x": 1700,
        "y": 190
      },
      "size": {
        "height": 18,
        "width": 18
      },
      "type": "Entry",
      "entryKind": "Initial",
      "attrs": {},
      "id": "1ef82dc2-0c68-4514-802f-73db7eb4e558",
      "z": 1098,
      "embeds": [
        "294dab23-93ec-4d81-91cd-2b37d6d5c8f2"
      ],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "position": {
        "x": 2040,
        "y": 386
      },
      "size": {
        "height": 60,
        "width": 60
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Passive",
          "fontSize": 11
        }
      },
      "id": "7b1028f0-5c3f-4ffe-a67e-35c439651036",
      "z": 1099,
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    },
    {
      "position": {
        "x": 1678,
        "y": 424
      },
      "size": {
        "width": 236,
        "height": 332
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
      "z": 1109,
      "embeds": [
        "83825638-1d05-496c-a71c-6f88e830501b",
        "963f0b59-6aae-4862-9c33-1b4e158e13b2",
        "b37d720f-11c3-4973-9eaa-6ca2569f636c",
        "dfc4d6cf-ac79-45c1-b9c8-2a7b249f01d6",
        "2e4b25b6-392d-4fef-93a7-514643a6be9b",
        "070579d7-38d0-49e0-b07b-c9f7e836c1ca",
        "6d205a79-a2fe-46a7-854d-45e63d9c9fbc",
        "a9d6f60b-2b13-4e20-bcff-bec7f929c0c4"
      ],
      "parent": "f1299df2-e8b4-43cd-8106-91793cbf98d4"
    },
    {
      "type": "NodeLabel",
      "label": true,
      "size": {
        "width": 15,
        "height": 15
      },
      "position": {
        "x": 1700,
        "y": 205
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
      "z": 1110,
      "parent": "1ef82dc2-0c68-4514-802f-73db7eb4e558"
    },
    {
      "position": {
        "x": 1731,
        "y": 458
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
      "z": 1111,
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "position": {
        "x": 1728,
        "y": 560
      },
      "size": {
        "height": 60,
        "width": 96
      },
      "type": "State",
      "attrs": {
        "name": {
          "text": "Participating",
          "fontSize": 11
        }
      },
      "id": "070579d7-38d0-49e0-b07b-c9f7e836c1ca",
      "z": 1112,
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "position": {
        "x": 1733,
        "y": 666
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
      "z": 1113,
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "position": {
        "x": 1881,
        "y": 474
      },
      "size": {
        "height": 18,
        "width": 18
      },
      "type": "Entry",
      "entryKind": "Initial",
      "attrs": {},
      "id": "a9d6f60b-2b13-4e20-bcff-bec7f929c0c4",
      "z": 1114,
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
        "x": 1881,
        "y": 489
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
      "z": 1119,
      "parent": "a9d6f60b-2b13-4e20-bcff-bec7f929c0c4"
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
      "z": 1120,
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
        "id": "6d205a79-a2fe-46a7-854d-45e63d9c9fbc"
      },
      "target": {
        "id": "7b1028f0-5c3f-4ffe-a67e-35c439651036",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "73.333%",
            "dy": "58.333%",
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
              "text": "after 3s\n/ bm.announce"
            }
          },
          "position": {
            "distance": 0.24228269562974833,
            "offset": 12.434722900390625,
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
      "id": "2cd42d87-7f66-403b-bb1f-61e024c03b25",
      "z": 1120,
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
              "text": "bm.leave_constellation\n/ bm.announce"
            }
          },
          "position": {
            "distance": 0.5652173913043478,
            "offset": -66,
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
      "z": 1120,
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
      "z": 1120,
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
      "z": 1120,
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
      "z": 1120,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 1693,
          "y": 497
        },
        {
          "x": 1693,
          "y": 708
        }
      ],
      "parent": "6a961907-2f8a-415b-aff0-38da579dd9f0"
    },
    {
      "type": "Transition",
      "attrs": {},
      "source": {
        "id": "7b1028f0-5c3f-4ffe-a67e-35c439651036"
      },
      "target": {
        "id": "f1299df2-e8b4-43cd-8106-91793cbf98d4",
        "anchor": {
          "name": "topLeft",
          "args": {
            "dx": "88.017%",
            "dy": "47.861%",
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
          "position": {
            "distance": 0.6780038694099261,
            "offset": -24,
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
      "id": "f594dd83-a7dc-444a-8df9-74f1d5852113",
      "z": 1120,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 2061,
          "y": 509
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
      "id": "f49fc90b-8d64-496d-8bef-3efa119e6073",
      "z": 1120,
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
      "z": 1120,
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
              "text": "hm.health_failed\n/ bm.announce"
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
      "z": 1120,
      "router": {
        "name": "normal"
      },
      "vertices": [
        {
          "x": 1981,
          "y": 368
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
              "text": "hm.health_failed\n/ bm.announce"
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
      "id": "23b485c9-1baa-4833-a244-afd80bebe8ac",
      "z": 1120,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [
        {
          "x": 2227,
          "y": 430
        }
      ],
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
      "z": 1120,
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
      "z": 1120,
      "router": {
        "name": "orthogonal"
      },
      "vertices": [],
      "parent": "c25e73f7-b5cb-4ab2-9379-a3df279bd0aa"
    }
  ]
}