import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Plus, Pencil, Trash2, Check, X, AlertCircle, ClipboardList } from 'lucide-react';
import './App.css';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000';

function App() {
  const [todos, setTodos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [newTodo, setNewTodo] = useState({ title: '', description: '' });
  const [editingId, setEditingId] = useState(null);
  const [editForm, setEditForm] = useState({ title: '', description: '' });

  // Fetch all todos
  const fetchTodos = async () => {
    try {
      setLoading(true);
      const response = await axios.get(`${API_URL}/api/todos`);
      setTodos(response.data.data || []);
      setError('');
    } catch (err) {
      setError('Failed to fetch todos. Make sure the backend is running.');
      console.error('Error fetching todos:', err);
    } finally {
      setLoading(false);
    }
  };

  // Create new todo
  const handleCreate = async (e) => {
    e.preventDefault();
    if (!newTodo.title.trim()) {
      setError('Title is required');
      return;
    }

    try {
      await axios.post(`${API_URL}/api/todos`, newTodo);
      setNewTodo({ title: '', description: '' });
      fetchTodos();
      setError('');
    } catch (err) {
      setError('Failed to create todo');
      console.error('Error creating todo:', err);
    }
  };

  // Update todo
  const handleUpdate = async (id) => {
    try {
      await axios.put(`${API_URL}/api/todos/${id}`, editForm);
      setEditingId(null);
      setEditForm({ title: '', description: '' });
      fetchTodos();
      setError('');
    } catch (err) {
      setError('Failed to update todo');
      console.error('Error updating todo:', err);
    }
  };

  // Toggle todo completion
  const handleToggleComplete = async (todo) => {
    try {
      await axios.put(`${API_URL}/api/todos/${todo.id}`, {
        completed: !todo.completed
      });
      fetchTodos();
    } catch (err) {
      setError('Failed to update todo');
      console.error('Error toggling todo:', err);
    }
  };

  // Delete todo
  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this todo?')) {
      try {
        await axios.delete(`${API_URL}/api/todos/${id}`);
        fetchTodos();
        setError('');
      } catch (err) {
        setError('Failed to delete todo');
        console.error('Error deleting todo:', err);
      }
    }
  };

  // Start editing
  const startEdit = (todo) => {
    setEditingId(todo.id);
    setEditForm({ title: todo.title, description: todo.description });
  };

  // Cancel editing
  const cancelEdit = () => {
    setEditingId(null);
    setEditForm({ title: '', description: '' });
  };

  useEffect(() => {
    fetchTodos();
  }, []);

  return (
    <div className="App">
      <div className="container">
        <header className="app-header">
          <h1>Todo List</h1>
          <p className="subtitle">DSO101 - CI/CD Assignment</p>
        </header>

        {error && (
          <div className="error-message">
            <AlertCircle size={18} />
            <span>{error}</span>
          </div>
        )}

        {/* Create Todo Form */}
        <form onSubmit={handleCreate} className="todo-form">
          <h2>Add New Todo</h2>
          <input
            type="text"
            placeholder="Enter todo title *"
            value={newTodo.title}
            onChange={(e) => setNewTodo({ ...newTodo, title: e.target.value })}
            className="input-field"
          />
          <textarea
            placeholder="Enter description (optional)"
            value={newTodo.description}
            onChange={(e) => setNewTodo({ ...newTodo, description: e.target.value })}
            className="input-field textarea-field"
            rows="3"
          />
          <button type="submit" className="btn btn-primary">
            <Plus size={18} />
            <span>Add Todo</span>
          </button>
        </form>

        {/* Todos List */}
        <div className="todos-section">
          <div className="section-header">
            <h2>My Todos</h2>
            <span className="todo-count">
              {todos.length} {todos.length === 1 ? 'item' : 'items'}
            </span>
          </div>

          {loading ? (
            <div className="loading">
              <div className="spinner"></div>
              <span>Loading todos...</span>
            </div>
          ) : todos.length === 0 ? (
            <div className="empty-state">
              <ClipboardList size={48} />
              <p>No todos yet</p>
              <span>Create your first todo above!</span>
            </div>
          ) : (
            <div className="todos-list">
              {todos.map((todo) => (
                <div
                  key={todo.id}
                  className={`todo-item ${todo.completed ? 'completed' : ''}`}
                >
                  {editingId === todo.id ? (
                    // Edit Mode
                    <div className="edit-form">
                      <input
                        type="text"
                        value={editForm.title}
                        onChange={(e) => setEditForm({ ...editForm, title: e.target.value })}
                        className="input-field"
                        placeholder="Todo title"
                      />
                      <textarea
                        value={editForm.description}
                        onChange={(e) => setEditForm({ ...editForm, description: e.target.value })}
                        className="input-field textarea-field"
                        rows="2"
                        placeholder="Description"
                      />
                      <div className="edit-actions">
                        <button
                          onClick={() => handleUpdate(todo.id)}
                          className="btn btn-success btn-sm"
                          type="button"
                        >
                          <Check size={14} />
                          <span>Save</span>
                        </button>
                        <button
                          onClick={cancelEdit}
                          className="btn btn-secondary btn-sm"
                          type="button"
                        >
                          <X size={14} />
                          <span>Cancel</span>
                        </button>
                      </div>
                    </div>
                  ) : (
                    // View Mode
                    <div className="todo-row">
                      <div className="todo-content">
                        <button
                          type="button"
                          className={`checkbox-btn ${todo.completed ? 'checked' : ''}`}
                          onClick={() => handleToggleComplete(todo)}
                          aria-label={todo.completed ? 'Mark as incomplete' : 'Mark as complete'}
                        >
                          {todo.completed && <Check size={14} strokeWidth={3} />}
                        </button>
                        <div className="todo-text">
                          <h3 className={todo.completed ? 'strikethrough' : ''}>
                            {todo.title}
                          </h3>
                          {todo.description && (
                            <p className="todo-description">{todo.description}</p>
                          )}
                          <span className="todo-date">
                            Created: {new Date(todo.created_at).toLocaleDateString()}
                          </span>
                        </div>
                      </div>
                      <div className="todo-actions">
                        <button
                          onClick={() => startEdit(todo)}
                          className="btn btn-icon"
                          disabled={todo.completed}
                          title="Edit"
                          type="button"
                        >
                          <Pencil size={16} />
                        </button>
                        <button
                          onClick={() => handleDelete(todo.id)}
                          className="btn btn-icon btn-icon-danger"
                          title="Delete"
                          type="button"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default App;
