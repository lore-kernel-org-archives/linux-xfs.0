Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40672 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731783AbfGHT7H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jul 2019 15:59:07 -0400
Date: Mon, 8 Jul 2019 12:59:06 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [Linux-kernel-mentees] [PATCH] Doc : fs : move xfs.txt to
 admin-guide
Message-ID: <20190708195906.GH32320@bombadil.infradead.org>
References: <20190705190412.GB32320@bombadil.infradead.org>
 <20190705193329.GA20933@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705193329.GA20933@localhost>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sheriff Esseson <sheriffesseson@gmail.com>
Cc: linux-kernel-mentees@lists.linuxfoundation.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org

On Fri, Jul 05, 2019 at 08:41:48PM +0100, Sheriff Esseson wrote:
> On Fri, Jul 05, 2019 at 12:04:12PM -0700, Matthew Wilcox wrote:
> > On Fri, Jul 05, 2019 at 02:14:46PM +0100, Sheriff Esseson wrote:
> > > As suggested by Matthew Wilcox, xfs.txt is primarily a guide on available
> > > options when setting up an XFS. This makes it appropriate to be placed under
> > > the admin-guide tree.
> > > 
> > > Thus, move xfs.txt to admin-guide and fix broken references.
> > 
> > What happened to the conversion to xfs.rst?
> 
> Okay, I was thinking placing the file properly should come first before the
> conversion.

But if you move it, then rename it, you have to change all these places
again.  The minimal conversion you did the first time was quite a nice diff
to read.
