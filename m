Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 17:16:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A0GLee024569
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 17:16:22 -0700
Date: Thu, 10 Apr 2008 10:16:51 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Recovering Data From Lost+Found
Message-ID: <20080410001651.GN108924158@sgi.com>
References: <720665D03D82304C98BA1EEDCE3EA6FE7A206C@exchange01.ortivawireless.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <720665D03D82304C98BA1EEDCE3EA6FE7A206C@exchange01.ortivawireless.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeffrey Sandel <JSandel@ortivawireless.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 09, 2008 at 11:25:28AM -0700, Jeffrey Sandel wrote:
> Last week we ran a firmware upgrade on a Coraid box with the drives
> mounted. The firmware upgrade corrupted part of the data and caused
> input output errors for users trying to acess the NFS mount. We then
> repaired the xfs file system with xfs_repair and all of the data was
> dumped into the lost+found directory without filenames or ownership of
> the files displayed, only inode numbers. I want to restore the data to
> it's oiginal state before the firmware upgrade and before the xfs
> _repair. Is there a command in xfs that you can do this with. 

Please check the archives before posting questions. There is a current
thread on exactly this topic. You'll find the answer there....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
