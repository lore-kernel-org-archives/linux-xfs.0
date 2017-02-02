Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58427 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751014AbdBBKUq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 05:20:46 -0500
Date: Thu, 2 Feb 2017 11:18:22 +0100
From: Greg KH <greg@kroah.com>
Subject: Re: 4.9-stable updates for XFS
Message-ID: <20170202101822.GA15184@kroah.com>
References: <1486022171-8076-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486022171-8076-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Feb 02, 2017 at 08:55:52AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> below are backports up to 4.10-rc6 for XFS.  I've selected all clear
> bugfixes for reported bugs.  I've skipped the finobt space reservation
> patch for now - I think it is stable material, but I want it to settle
> a bit more first.

Thanks for all of these, now all applied.

greg k-h
