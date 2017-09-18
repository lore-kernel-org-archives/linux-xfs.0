Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdIRIcK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 04:32:10 -0400
Date: Mon, 18 Sep 2017 10:31:34 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: 4.13-stable updates for XFS
Message-ID: <20170918083134.GA1261@kroah.com>
References: <20170917210631.10725-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170917210631.10725-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, Sep 17, 2017 at 02:06:06PM -0700, Christoph Hellwig wrote:
> Hi all,
> 
> below are backports up to 4.14-rc1 for XFS.  I've selected all
> clear bugfixes for reported bugs, and a few harmless prep patches
> that allow us to carry late bug fixes as-is instead of providing
> special versions for -stable, which in the past have caused more
> harm than good.

Thanks for these, all now queued up.

And I agree with the "as-is" stuff, with the prep patches, that's the
best way to go.

thanks,

greg k-h
