Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60836 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751123AbeBHCVq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 21:21:46 -0500
Date: Wed, 7 Feb 2018 18:21:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove unused m_dmevmask from xfs_mount struct
Message-ID: <20180208022138.GG5433@magnolia>
References: <e62db8d7-73d8-c47c-cd42-977d24aba0ce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e62db8d7-73d8-c47c-cd42-977d24aba0ce@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Feb 06, 2018 at 07:54:55PM -0600, Eric Sandeen wrote:
> The dmevmask structure member is a dmapi leftover; it's
> set here and there but never actually used.  Remove it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
