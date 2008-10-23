Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 22:37:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9N5bWFI005348
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 22:37:32 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 418C41464706
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 22:39:17 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 1Q4BUxNLxiadZLe9 for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 22:39:17 -0700 (PDT)
Date: Thu, 23 Oct 2008 16:39:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: crash with latest code drop.
Message-ID: <20081023053912.GZ18495@disturbed>
References: <48F54C20.8060704@sgi.com> <20081015011857.GS10716@disturbed> <20081015022948.GA20966@infradead.org> <20081015031645.GA25906@disturbed> <20081015032431.GA7426@infradead.org> <20081015035116.GB25906@disturbed> <48F584B8.8060907@sgi.com> <20081015061917.GC25906@disturbed> <20081022061905.GI18495@disturbed> <48FFFC5F.2030307@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FFFC5F.2030307@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 23, 2008 at 02:23:59PM +1000, Peter Leckie wrote:
> Hey Dave I'll push it now, I assume it's ok to go in with out the check  
> for a inode first
> as the combine linux/XFS inode patch is in.

Yes, it's safe to go in as it stands. Thanks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
