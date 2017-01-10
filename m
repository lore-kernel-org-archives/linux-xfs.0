Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47472 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760853AbdAJKh2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 05:37:28 -0500
Date: Tue, 10 Jan 2017 11:37:48 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: 4.9-stable updates for XFS
Message-ID: <20170110103748.GA8466@kroah.com>
References: <1483976343-661-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jan 09, 2017 at 04:38:31PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> below are backports from 4.10-rc3 for XFS.  I've selected all clear
> bugfixes for reported bugs, and added about a handful of small
> infrastructure backports so that we can take the fixes as is instead of
> having to redo them in a different way than upstream.
> 
> These have passed xfstests on top of Linux 4.9.2.  Even if some of the 
> patches might apply to older stable trees please do not backport them 
> unless someone volunteers to QA them first.

Many thanks for these, all now queued up.

greg k-h
