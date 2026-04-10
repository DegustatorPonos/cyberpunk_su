import './App.css';
import Sidebar from './Emelents/Sidebar';
import { createBrowserRouter, RouterProvider } from 'react-router';
import IndexElement from './Emelents/IndexElement';
import ClassesList from './Emelents/ClassList';

const router = createBrowserRouter([
    {
        index: true,
        element: (<IndexElement />),
    },
    {
        path: "/classes",
        element: (<ClassesList />),
    },
]);

function App() {
    return (
        <div>
            <Sidebar />
            <RouterProvider router={router} />
        </div>
    );
}

export default App;
