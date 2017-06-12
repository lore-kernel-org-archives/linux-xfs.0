Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55472 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751966AbdFLHos (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2017 03:44:48 -0400
Date: Mon, 12 Jun 2017 09:44:41 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Request for inclusion of b54554ac5afa ("Make
 __xfs_xattr_put_listen preperly report errors.")
Message-ID: <20170612074441.GA9957@kroah.com>
References: <f29b6c4b-3f22-21b1-a02a-5331d22ee485@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f29b6c4b-3f22-21b1-a02a-5331d22ee485@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, darrick.wong@oracle.com, asavkov@redhat.com

On Mon, Jun 12, 2017 at 10:24:16AM +0300, Nikolay Borisov wrote:
> Hello,
> 
> I'd like to request the inclusion of the aforementioned patch. It is
> needed as an addition to 2a6fba6d2311 ("xfs: only return -errno or
> success from attr ->put_listent") which was already included in 4.4.71.

What kernel tree(s) do you wish to see this included in?

thanks,

greg k-h
