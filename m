Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48922 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728308AbeGZCY6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 22:24:58 -0400
Subject: Re: [PATCH 07/10] xfs_scrub: rename NOFIX_COMPLAIN to be less
 confusing
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
 <153006771523.20121.7089644598888393327.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <10bdb449-fda5-910c-627a-e31b831357e4@sandeen.net>
Date: Wed, 25 Jul 2018 18:10:39 -0700
MIME-Version: 1.0
In-Reply-To: <153006771523.20121.7089644598888393327.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 6/26/18 7:48 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rename NOFIX_COMPLAIN to COMPLAIN_IF_UNFIXED so that the symbolic name
> is less confusing as to what the flag is supposed to mean.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Yay for clarity ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


