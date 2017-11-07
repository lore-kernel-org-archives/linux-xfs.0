Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753543AbdKGHj3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2017 02:39:29 -0500
Date: Tue, 7 Nov 2017 08:39:40 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171107073940.GB4654@kroah.com>
References: <20171107020607.GA26910@magnolia>
 <20171107072040.GB4586@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171107072040.GB4586@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, linux-kernel@vger.kernel.org

On Mon, Nov 06, 2017 at 11:20:40PM -0800, Christoph Hellwig wrote:
> NAK, for both the libxfs patch and the kernel one.

What libxfs patch?  And what "kernel one" are you referring to here?

> I wrote the file and it has no copyright header because it conatians
> trivial, non-copyrightable code.

What file exactly?

And from what I know, there is nothing that is "non-copyrightable".

And this isn't changing the copyright of _ANYTHING_ it is just putting
the explicit license of the file, on each file in the kernel, because it
needs to be tracked.

> I don't know why people think they can touch license information on
> files I've written without even asking me.

Nothing was changed, the license should be the exact same as it was
before.  But as I don't know what file you are referring to here, it's a
bit hard to determine what you are talking about exactly :(

thanks,

greg k-h
