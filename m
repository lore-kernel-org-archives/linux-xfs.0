Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48054 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755452AbcINHTP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Sep 2016 03:19:15 -0400
Date: Wed, 14 Sep 2016 09:19:10 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Message-ID: <20160914071910.GC17278@lst.de>
References: <1473438884-674-1-git-send-email-hch@lst.de> <1473438884-674-7-git-send-email-hch@lst.de> <20160913231039.GF26002@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160913231039.GF26002@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

On Tue, Sep 13, 2016 at 05:10:39PM -0600, Ross Zwisler wrote:
> If you stick a space in front of the labels (as is done in the rest of dax.c)
> it prevents future patches from using them at the beginning of hunks.  Here's a
> patch adding a random space as an example:

The spaces in front of labels are a fairly horrible style.  But given
that the rest of the file uses them I'll add them back.
