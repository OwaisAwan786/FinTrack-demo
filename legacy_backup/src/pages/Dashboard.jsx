import React, { useState } from 'react';
import { useFinTrack } from '../context/FinTrackContext';
import { TrendingUp, TrendingDown, DollarSign, Plus, Eye, EyeOff } from 'lucide-react';
import StatsWidget from '../components/StatsWidget';
import SavingsPocketWidget from '../components/SavingsPocketWidget';
import TransactionList from '../components/TransactionList';
import { formatCurrency } from '../utils/format';

const Dashboard = () => {
    const { totalBalance, monthlySpending, savingsPocket, transactions, addTransaction } = useFinTrack();
    const [isSimulating, setIsSimulating] = useState(false);
    const [showBalance, setShowBalance] = useState(false); // Default hidden for privacy

    // Quick simulation to show the "Save remaining" feature
    const handleSimulatePurchase = () => {
        setIsSimulating(true);
        // Simulate buying something for 900
        const price = 900;

        // Add transaction
        setTimeout(() => {
            addTransaction({
                id: Date.now(),
                title: 'Fancy Dinner',
                amount: price,
                category: 'Food',
                date: new Date().toISOString().split('T')[0],
                type: 'expense'
            });
            setIsSimulating(false);
        }, 600);
    };

    return (
        <div className="flex flex-col gap-8 pb-10">
            {/* Header */}
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h2 className="text-3xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-white to-gray-400">
                        Welcome Back!
                    </h2>
                    <p className="text-gray-400 mt-1">Here's your financial overview for today.</p>
                </div>
                <div className="flex items-center gap-3">
                    <button
                        onClick={() => setShowBalance(!showBalance)}
                        className="btn btn-secondary"
                        title={showBalance ? "Hide Balance" : "Show Balance"}
                    >
                        {showBalance ? <EyeOff size={18} /> : <Eye size={18} />}
                        {showBalance ? "Hide Balance" : "Show Balance"}
                    </button>
                    <button
                        onClick={handleSimulatePurchase}
                        disabled={isSimulating}
                        className="btn btn-primary"
                    >
                        <Plus size={18} />
                        {isSimulating ? 'Processing...' : 'Simulate Spend (Rs. 900)'}
                    </button>
                </div>
            </div>

            {/* Top Stats Grid */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <StatsWidget
                    title="Total Balance"
                    amount={showBalance ? formatCurrency(totalBalance) : 'PKR ****'}
                    icon={DollarSign}
                    trend="+2.5%"
                    trendUp={true}
                />
                <StatsWidget
                    title="Monthly Spending"
                    amount={showBalance ? formatCurrency(monthlySpending) : 'PKR ****'}
                    icon={TrendingDown}
                    trend="Within Budget"
                    trendUp={true}
                />
                <SavingsPocketWidget balance={showBalance ? formatCurrency(savingsPocket) : 'PKR ****'} />
            </div>

            {/* Main Content Grid */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                {/* Left Col - 2/3 width */}
                <div className="lg:col-span-2 flex flex-col gap-8">
                    {/* Chart Mockup (Placeholder for now) */}
                    <div className="card min-h-[300px] flex items-center justify-center border-dashed border-2 border-slate-700 bg-slate-800/30">
                        <div className="text-center">
                            <TrendingUp size={48} className="mx-auto text-slate-600 mb-4" />
                            <p className="text-slate-500">Spending Analytics coming soon...</p>
                        </div>
                    </div>

                    <TransactionList transactions={transactions} />
                </div>

                {/* Right Col - 1/3 width */}
                <div className="flex flex-col gap-6">
                    {/* Budget Progress */}
                    <div className="card">
                        <h3 className="font-bold mb-4">Monthly Budget</h3>
                        <div className="flex justify-between text-sm mb-2">
                            <span className="text-gray-400">Spent</span>
                            <span className="text-white font-medium">{formatCurrency(monthlySpending)} / {formatCurrency(20000)}</span>
                        </div>
                        <div className="w-full bg-slate-700 rounded-full h-3 overflow-hidden">
                            <div
                                className="bg-gradient-to-r from-indigo-500 to-purple-500 h-full rounded-full"
                                style={{ width: `${Math.min((monthlySpending / 20000) * 100, 100)}%` }}
                            />
                        </div>
                        <p className="text-xs text-gray-500 mt-3">
                            You have spent {Math.round((monthlySpending / 20000) * 100)}% of your budget.
                        </p>
                    </div>

                    {/* Simple AI Tip */}
                    <div className="glass-panel p-6 border-l-4 border-emerald-500">
                        <h4 className="font-bold text-emerald-400 mb-2">Smart Tip</h4>
                        <p className="text-sm text-gray-300 leading-relaxed">
                            Great job! You saved Rs. 100 extra this week by skipping coffee. That's enough for a small treat!
                        </p>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Dashboard;
