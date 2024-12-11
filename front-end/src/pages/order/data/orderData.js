export const navigation = {
  general: [
    { name: 'Dashboard', icon: 'LayoutDashboard', href: '#' },
    { name: 'Order Summary', icon: 'FileText', href: '#', current: true },
    { name: 'Transaction', icon: 'FileText', href: '#' },
    { name: 'Mess', icon: 'MessageSquare', href: '#' },
    { name: 'Product', icon: 'Package', href: '/product' },
  ],
  support: [
    { name: 'Account', icon: 'User', href: '#' },
    { name: 'Settings', icon: 'Settings', href: '#' },
    { name: 'Logout', icon: 'LogOut', href: '#' },
  ]
}

export const tabs = [
  { name: 'All Order', count: null },
  { name: 'Received', count: 20 },
  { name: 'Shipping', count: 39 },
  { name: 'Complaint', count: 1 },
  { name: 'Canceled', count: 4 },
  { name: 'Done', count: 2034 },
]

export const orders = [
  {
    id: 'P909',
    customer: 'Jimmy Alan',
    type: 'bodycare',
    amount: 233.00,
    date: 'Nov 23,2023',
    status: 'Received'
  },
  {
    id: 'P910',
    customer: 'Dianne Russell',
    type: 'Haircare',
    amount: 233.00,
    date: 'Nov 23,2023',
    status: 'Shipping'
  },
  {
    id: 'P911',
    customer: 'Wade Warren',
    type: 'Skincare',
    amount: 233.00,
    date: 'Nov 23,2023',
    status: 'Shipping'
  },
  {
    id: 'P912',
    customer: 'Brooklyn',
    type: 'bodycare',
    amount: 233.00,
    date: 'Nov 23,2023',
    status: 'Canceled'
  },
  {
    id: 'P913',
    customer: 'Leslie Alexander',
    type: 'bodycare',
    amount: 233.00,
    date: 'Nov 23,2023',
    status: 'Done'
  },
  {
    id: 'P914',
    customer: 'Jenny Wilson',
    type: 'Haircare',
    amount: 233.00,
    date: 'Nov 23,2023',
    status: 'Done'
  },
  {
    id: 'P915',
    customer: 'Guy Hawkins',
    type: 'bodycare',
    amount: 233.00,
    date: 'Nov 23,2023',
    status: 'Complaint'
  },
  {
    id: 'P916',
    customer: 'Robert Fox',
    type: 'Skincare',
    amount: 233.00,
    date: 'Nov 23,2023',
    status: 'Done'
  }
]
