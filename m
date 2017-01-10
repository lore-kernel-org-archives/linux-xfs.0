Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47203 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942556AbdAJAV7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 19:21:59 -0500
Date: Mon, 9 Jan 2017 16:21:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: 4.9-stable updates for XFS
Message-ID: <20170110002153.GG14038@birch.djwong.org>
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

FWIW the list looks reasonable to me.

--D

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
