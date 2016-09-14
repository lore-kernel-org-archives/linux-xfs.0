Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48032 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751790AbcINHIf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Sep 2016 03:08:35 -0400
Date: Wed, 14 Sep 2016 09:08:32 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/10] iomap: add IOMAP_F_NEW flag
Message-ID: <20160914070832.GB17278@lst.de>
References: <1473438884-674-1-git-send-email-hch@lst.de> <1473438884-674-2-git-send-email-hch@lst.de> <20160913224357.GA26002@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160913224357.GA26002@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

On Tue, Sep 13, 2016 at 04:43:57PM -0600, Ross Zwisler wrote:
> On Fri, Sep 09, 2016 at 06:34:35PM +0200, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Though I guess I've never seen a patch with a completely empty changelog
> before?  :)   Maybe it's okay for really easy patches?  I just thought I'd get
> shouted down for doing it.

I think it's ok and others do it a lot too (e.g. Al Viro).  But I've been
shouted at for it from others nevertheless..
