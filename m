Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Aug 2006 22:56:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7S5uZDW029724
	for <xfs@oss.sgi.com>; Sun, 27 Aug 2006 22:56:46 -0700
Message-Id: <200608280555.PAA03288@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory
Date: Mon, 28 Aug 2006 15:57:02 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20060827072123.GA3875@apartia.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Louis-David Mitterrand' <ldm@apartia.org>
Cc: xfs@oss.sgi.com

 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Louis-David Mitterrand
> Sent: Sunday, 27 August 2006 5:21 PM
> To: xfs@oss.sgi.com
> Subject: libxfs_initbuf can't memalign 4096 bytes: Cannot 
> allocate memory
> 
> Package: xfsprogs
> Version: 2.8.11-1
> Followup-For: Bug #382935
> 
> Hello,
> 
> Using xfs_repair on a 2TB partition I get:
[snip] 
> 	xfs_repair: libxfs_initbuf can't memalign 4096 bytes: 
> Cannot allocate memory
 
Can you tell me how many inodes you have on your filesystem?
