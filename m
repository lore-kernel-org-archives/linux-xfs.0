Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:21206 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbdANH6o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Jan 2017 02:58:44 -0500
Date: Fri, 13 Jan 2017 23:06:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [LSF/MM ATTEND] XFS, VFS, pmem, and ext4 topics
Message-ID: <20170114070600.GF5883@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

Hi,

I'd like to attend LSF/MM again this year to participate in the
discussions around XFS, VFS, pmem, and possibly ext4.  I'm interested in
talking to the pmem developers about integrating DAX with CoW and
stabilizing DAX support within existing filesystems.  I also want to
talk about online scrubbing and filesystem repair in XFS[1] with an eye
towards some of the less savory interactions it has with the VFS to
quiesce userland interactions.

If there's a session about the fsync and IO errors; or VFS file and
directory encryption I'd probably attend that as well.  Since I'm the
XFS maintainer now I'd also appreciate the chance to organize an XFS BOF
with the other developers.

If there's time I'll also catch up with the ext4 developers to see what
they're working on.

--D

[1] I'd also chat with the ocfs2 developers about their implementation
if any of them attend.
