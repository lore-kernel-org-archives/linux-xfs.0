Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 15:46:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6KMjcDW031499
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 15:45:50 -0700
Date: Fri, 21 Jul 2006 08:44:51 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: preallocate near a specified block
Message-ID: <20060721084451.E1990742@wobbly.melbourne.sgi.com>
References: <cfac95650607200738o1bf811e8r1493c4bbcf13e24b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfac95650607200738o1bf811e8r1493c4bbcf13e24b@mail.gmail.com>; from willcor@gmail.com on Thu, Jul 20, 2006 at 03:38:27PM +0100
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Roger Willcocks <willcor@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 20, 2006 at 03:38:27PM +0100, Roger Willcocks wrote:
> Hi folks,
> 
> I've put together a 'preallocate near' ioctl, which I've been using in
> anger for several months now. The changes are pretty minimal, and boil
> down to making xfs_bmap think it's extending a file instead of doing
> an initial allocation.
> ...
> Any interest?

Definately.

Have you tweaked xfs_io to be able to exercise this functionality
too?  (also describing it in the xfsctl man page would be good).

cheers.

-- 
Nathan
