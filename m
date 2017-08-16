Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:47215 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752219AbdHPVsI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Aug 2017 17:48:08 -0400
Date: Thu, 17 Aug 2017 07:48:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: Signed-off-by missing for commit in the xfs tree
Message-ID: <20170817074805.1071434d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paul Menzel <pmenzel@molgen.mpg.de>

Hi all,

Commit

  74456cceed0b ("iomap: fix integer truncation issues in the zeroing and dirtying helpers")

is missing a Signed-off-by from its author.

-- 
Cheers,
Stephen Rothwell
