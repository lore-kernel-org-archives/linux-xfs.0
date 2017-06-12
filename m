Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbdFLM7a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2017 08:59:30 -0400
Date: Mon, 12 Jun 2017 14:59:23 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Request for inclusion of b54554ac5afa ("Make
 __xfs_xattr_put_listen preperly report errors.")
Message-ID: <20170612125923.GA12197@kroah.com>
References: <f29b6c4b-3f22-21b1-a02a-5331d22ee485@suse.com>
 <20170612123312.GD17001@kroah.com>
 <a59171e2-9962-00c6-977f-45b668ca96c6@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a59171e2-9962-00c6-977f-45b668ca96c6@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, darrick.wong@oracle.com, asavkov@redhat.com

On Mon, Jun 12, 2017 at 03:40:08PM +0300, Nikolay Borisov wrote:
> 
> 
> On 12.06.2017 15:33, Greg KH wrote:
> > On Mon, Jun 12, 2017 at 10:24:16AM +0300, Nikolay Borisov wrote:
> >> Hello,
> >>
> >> I'd like to request the inclusion of the aforementioned patch.
> > 
> > What patch?  Commit b54554ac5afa is not in any kernel tree that I can
> > find :(
> 
> Yeah, I tested this particular patch but I might have copied the ID from
> an internal tree. The upstream patch is:
> 
> 791cc43b36eb ("Make __xfs_xattr_put_listen preperly report errors.")
> 
> It's a single one-liner and it applies cleanly on 4.4

Ok, thanks, please be more careful next time...

now queued up.

greg k-h
