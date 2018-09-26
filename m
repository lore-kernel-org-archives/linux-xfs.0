Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:14871 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbeI0FhC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Sep 2018 01:37:02 -0400
Date: Thu, 27 Sep 2018 09:21:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/24] docs: carry a copy of the CC-by-SA 3.0 license
Message-ID: <20180926232140.GE31060@dastard>
References: <153799045443.31202.17537455000771265705.stgit@magnolia>
 <153799046767.31202.13234065186281153272.stgit@magnolia>
 <20180926213028.GA22763@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180926213028.GA22763@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Sep 26, 2018 at 02:30:28PM -0700, Christoph Hellwig wrote:
> On Wed, Sep 26, 2018 at 12:34:27PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add the CC-BY-SA 3.0 license so that the XFS Data Structures &
> > Algorithms book can reference it with spdx headers.
> 
> NAK.  We should not add random new licenses to the kernel tree.

Given these patches are all CC-BY-SA-3.0+ (i.e. they have an "or
later" clause in them), and the kernel already has
LICENSES/other/CC-BY-SA-4.0, why not just put them under the license
that the kernel already supports?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
