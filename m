Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17127 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756806AbcIOFbB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Sep 2016 01:31:01 -0400
Date: Wed, 14 Sep 2016 22:30:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Message-ID: <20160915053052.GI9314@birch.djwong.org>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de>
 <20160913231039.GF26002@linux.intel.com>
 <20160914071910.GC17278@lst.de>
 <20160914170759.GA14196@linux.intel.com>
 <20160915051229.GD6188@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160915051229.GD6188@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

On Thu, Sep 15, 2016 at 07:12:29AM +0200, Christoph Hellwig wrote:
> On Wed, Sep 14, 2016 at 11:07:59AM -0600, Ross Zwisler wrote:
> > I'll bite - why do you think adding a space before labels is a "fairly
> > horrible style"?  Adding them gives a tangible benefit for unified diffs and
> > patches because it's much more useful to know that a change is in a given
> > function than that it follows a label called "out", which could be defined
> > many times in a given file.  Again, the example:
> 
> It's a space based indent in a tab based world.  And with git you can
> get your enhanced diff output with just a small tweak to the git setting.
> Which we're incidentally about to finally get for the kernel tree.

What setting /is/ that, by the way?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
