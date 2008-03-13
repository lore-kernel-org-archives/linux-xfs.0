Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Mar 2008 00:15:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2D7F9GT000566
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2008 00:15:12 -0700
Received: from mail.flatline.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DD7CF7FEC1
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2008 00:15:41 -0700 (PDT)
Received: from mail.flatline.de (flatline.de [80.190.243.144]) by cuda.sgi.com with ESMTP id OX1HAB6mnb1cdJr9 for <xfs@oss.sgi.com>; Thu, 13 Mar 2008 00:15:41 -0700 (PDT)
Date: Thu, 13 Mar 2008 08:14:45 +0100
From: Andreas Kotes <count@flatline.de>
Subject: Re: XFS internal error
Message-ID: <20080313071445.GA30874@slop.flatline.de>
References: <470831E6.4030704@fastmail.co.uk> <20071008001452.GX995458@sgi.com> <20080310122216.GG14256@slop.flatline.de> <20080310223018.GA155407@sgi.com> <20080310225927.GP14256@slop.flatline.de> <20080310234539.GC155407@sgi.com> <20080311134746.GQ14256@slop.flatline.de> <20080312175050.GD14256@slop.flatline.de> <20080313000121.GU155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313000121.GU155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Hallo Dave,

* David Chinner <dgc@sgi.com> [20080313 01:01]:
> On Wed, Mar 12, 2008 at 06:50:50PM +0100, Andreas Kotes wrote:
> > * Andreas Kotes <count-linux@flatline.de> [20080311 14:47]:
> > > I basically build a PXE image which does an xfs_repair -L /dev/sda2 from
> > > initrd - and the problem persists. Sigh. Exactly no change.
> 
> Do you do this on every boot?

no, I did this on a6b and a7b so far, where the problems I mentioned
occur, and only after I saw these in-memory problems. in general, XFS
proves to be realiable for us.

would you recommend running an xfs_check before running an xfs_repair in
case of problems?

Br,

   Andreas

-- 
flatline IT services - Andreas Kotes - Tailored solutions for your IT needs
