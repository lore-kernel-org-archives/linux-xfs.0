Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Nov 2006 07:20:08 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAFFJxaG019672
	for <xfs@oss.sgi.com>; Wed, 15 Nov 2006 07:20:01 -0800
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77351D1D3103
	for <xfs@oss.sgi.com>; Wed, 15 Nov 2006 07:19:10 -0800 (PST)
Message-ID: <455B2FDD.3090303@sandeen.net>
Date: Wed, 15 Nov 2006 09:18:53 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: SLES 9 x86: xfs_force_shutdown
References: <18773.62.159.242.114.1163581669.squirrel@groupware.pawisda.de>
In-Reply-To: <18773.62.159.242.114.1163581669.squirrel@groupware.pawisda.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dan Am <xfs@lonx.net>
Cc: xfs@oss.sgi.com

Dan Am wrote:
> Hello ,
> this has come up before, I have read up on some threads, esp from Feb this
> year and it is probably handled by now. (Is it ?)
> 
> Heres the log:
> Nov 14 15:31:05 l08arnfs01 kernel: xfs_force_shutdown(dm-0,0x8) called
> from line 1091 of file fs/xfs/xfs_trans.c.  Return address =
> 0xffffffffa01035e8
> Nov 14 15:42:55 l08arnfs01 kernel: xfs_force_shutdown(dm-0,0x1) called
> from line 353 of file fs/xfs/xfs_rw.c.  Return address =
> 0xffffffffa01035e8

Any interesting messages before this, from xfs, or from storage subsystems.. or 
anywhere?

-Eric
