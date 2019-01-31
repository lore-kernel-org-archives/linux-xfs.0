Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbfAaSU2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 13:20:28 -0500
Date: Thu, 31 Jan 2019 19:20:25 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 00/10] xfs: stable fixes for v4.19.y
Message-ID: <20190131182025.GC4989@kroah.com>
References: <20190131180919.2500-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131180919.2500-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, Alexander.Levin@microsoft.com, amir73il@gmail.com, hch@infradead.org

On Thu, Jan 31, 2019 at 10:09:09AM -0800, Luis Chamberlain wrote:
> I've volunteered to help with stable XFS maintenance at LSFMM. This is
> the initial set of work as a result of this.
> 
> For stable v4.20.y I have not identified any candidate fixes. I'll keep
> monitoring development for potential fixes.

When sending stable stuff, always cc: stable@vger.kernel.org, I'm not
the only stable kernel developer these days :)

As I said for the 01/10 patch, I need the upstream git commit ids in
here to be able to take them.

That being said, this is really good stuff, thanks for doing this work.

thanks,

greg k-h
