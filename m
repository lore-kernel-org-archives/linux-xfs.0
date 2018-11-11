Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:3710 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731254AbeKLJX2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Nov 2018 04:23:28 -0500
Date: Mon, 12 Nov 2018 10:33:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Fix coding style issue in xfs_acl.c and xfs_aops.c
Message-ID: <20181111233305.GL19305@dastard>
References: <20181111003603.7598-1-weizhefix@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181111003603.7598-1-weizhefix@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hmsjwzb <weizhefix@gmail.com>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Nov 11, 2018 at 08:36:03AM +0800, hmsjwzb wrote:
> Possible unwrapped commit description (prefer a maximum 75 chars per line)

NACK. Our preference is (and always has been) for comments to fill
the entire 80 columns, just like the rest of the kernel. I have no
idea who told you "75 columns is preferred" but they are wrong.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
