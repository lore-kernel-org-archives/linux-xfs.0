Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:17:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97LH3U0027093
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:17:03 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 938024C5EEE
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:18:42 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id BlIbnKHlIHPqsqBk for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:18:42 -0700 (PDT)
Date: Wed, 8 Oct 2008 08:18:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] kill XFS_LITINO
Message-ID: <20081007211839.GT30001@disturbed>
References: <20081007202153.GA16485@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007202153.GA16485@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Oct 07, 2008 at 10:21:53PM +0200, Christoph Hellwig wrote:
> No point having a macro that just derefences a member of the struct
> pointer passed in.

Looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
