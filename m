Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49983 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753320AbcJKQXd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2016 12:23:33 -0400
Date: Tue, 11 Oct 2016 09:22:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/9] iomap: add IOMAP_REPORT
Message-ID: <20161011162236.GG22379@birch.djwong.org>
References: <1476106685-29048-1-git-send-email-hch@lst.de>
 <1476106685-29048-2-git-send-email-hch@lst.de>
 <20161011014546.GF22379@birch.djwong.org>
 <20161011144557.GA16368@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161011144557.GA16368@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Oct 11, 2016 at 04:45:57PM +0200, Christoph Hellwig wrote:
> Just curious:  did you maybe manage to only rebuild the xfs module
> and not the core code and have a mismatch of the flags values?

D'oh!  Yes, I forgot to reboot the VMs to pick up the new vmlinux.  Everything
checks out now.

--D
