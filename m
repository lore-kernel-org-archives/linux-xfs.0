Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4240 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751658AbeCVXtH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 19:49:07 -0400
Date: Fri, 23 Mar 2018 10:49:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: file corruptions, 2nd half of 512b block
Message-ID: <20180322234904.GE18129@dastard>
References: <20180322150226.GA31029@onthe.net.au>
 <20180322180327.GI16617@bfoster.bfoster>
 <20180322230450.GT1150@dastard>
 <20180322232629.GF4818@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180322232629.GF4818@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org

On Thu, Mar 22, 2018 at 04:26:29PM -0700, Darrick J. Wong wrote:
> On Fri, Mar 23, 2018 at 10:04:50AM +1100, Dave Chinner wrote:
> > Unfortunately, I can't find the repository for the data checking
> > tools that were developed years ago for doing exactly this sort of
> > testing (genstream+checkstream) online anymore - they seem to
> > have disappeared from the internet. (*) Shouldn't be too hard to
> > write a quick tool to do this, though.
> 
> https://sourceforge.net/projects/checkstream/ ?

Thanks, Darrick!

FWIW, did I mention that google is totally useless as a search
engine these days?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
