import './App.css';
import './Fonts.css';
import Sidebar from './Emelents/Sidebar';
import { createBrowserRouter, RouterProvider } from 'react-router';
import IndexElement from './Emelents/IndexElement';
import ClassesList from './Emelents/ClassList';
import Topbar from './Emelents/Topbar';

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
        <div className='App'>
            <Topbar />
            <div className='AppContents'>
                <Sidebar />
                <RouterProvider router={router} />
            </div>
        </div>
    );
}

export default App;
