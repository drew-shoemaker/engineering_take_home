import React, { useEffect } from 'react';
import styles from './FlashMessage.module.css';

const FlashMessage = ({ message, type = 'success', duration = 3000, onClose }) => {
  useEffect(() => {
    const timer = setTimeout(() => {
      onClose();
    }, duration);

    return () => clearTimeout(timer);
  }, [duration, onClose]);

  return (
    <div className={`${styles.flash} ${styles[type]}`}>
      {message}
    </div>
  );
};

export default FlashMessage; 