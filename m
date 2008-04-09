Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 11:20:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m39IKi7t032268
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 11:20:45 -0700
Received: from exchange01.ortivawireless.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC089983ABB
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2008 11:21:21 -0700 (PDT)
Received: from exchange01.ortivawireless.com (mail.ortivawireless.com [216.86.136.74]) by cuda.sgi.com with ESMTP id mGliif9nSCeLGPuD for <xfs@oss.sgi.com>; Wed, 09 Apr 2008 11:21:21 -0700 (PDT)
MIME-Version: 1.0
Subject: Recovering Data From Lost+Found
Date: Wed, 9 Apr 2008 11:25:28 -0700
Message-ID: <720665D03D82304C98BA1EEDCE3EA6FE7A206C@exchange01.ortivawireless.com>
From: "Jeffrey Sandel" <JSandel@ortivawireless.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Last week we ran a firmware upgrade on a Coraid box with the drives
mounted. The firmware upgrade corrupted part of the data and caused
input output errors for users trying to acess the NFS mount. We then
repaired the xfs file system with xfs_repair and all of the data was
dumped into the lost+found directory without filenames or ownership of
the files displayed, only inode numbers. I want to restore the data to
it's oiginal state before the firmware upgrade and before the xfs
_repair. Is there a command in xfs that you can do this with. 

 

The NFS server is running Ubuntu 6.10.

 

Thank you for your assistance with this matter.

 

 

 

 

 

Jeffrey Sandel

Network Manager

Ortiva Wireless

(858) 704-1524 - Office

(619) 961-6346 - Mobile

jsandel@ortivawireless.com <mailto:jsandel@ortivawireless.com> 

 



[[HTML alternate version deleted]]
