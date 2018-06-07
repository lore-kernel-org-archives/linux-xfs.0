Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38004 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932251AbeFGUpr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 16:45:47 -0400
Date: Thu, 7 Jun 2018 22:45:44 +0200
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH v3 1/2] vfs: allow dedupe of user owned read-only files
Message-ID: <20180607204544.GB28053@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20180607173854.15747-1-mfasheh@suse.de>
 <20180607173854.15747-2-mfasheh@suse.de>
 <20180607181751.GN25007@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180607181751.GN25007@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>

Hi Darrick,

On Thu, Jun 07, 2018 at 11:17:51AM -0700, Darrick J. Wong wrote:
> Looks ok, but could you please update the manpage for
> ioctl_fideduperange to elaborate on when userspace can expect EPERM?
> 
> Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

Yes, good idea. I can handle that.

Thanks,
	--Mark
