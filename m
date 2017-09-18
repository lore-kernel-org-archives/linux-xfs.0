Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47262 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752208AbdIRIWl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 04:22:41 -0400
Date: Mon, 18 Sep 2017 10:22:51 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: 4.9-stable updates for XFS
Message-ID: <20170918082251.GA29399@kroah.com>
References: <20170917210712.10804-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, Sep 17, 2017 at 02:06:25PM -0700, Christoph Hellwig wrote:
> Hi all,
> 
> below are backports up to 4.14-rc1 for XFS.  I've selected all
> clear bugfixes for reported bugs, and a few harmless prep patches
> that allow us to carry late bug fixes as-is instead of providing
> special versions for -stable, which in the past have caused more
> harm than good.
> 
> In addition to the patches for 4.13-stable there also are various
> patches that are in 4.13 but not in 4.9-stable yet.

Thanks for all of these, now queued up.

greg k-h
