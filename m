Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47308 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752011AbeADS3Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 13:29:24 -0500
Subject: Re: [PATCH 4/5] xfs_repair: fix libxfs namespace problems
References: <151500479880.7713.6538509149156363572.stgit@magnolia>
 <151500483196.7713.13575201997749465948.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6a6ca64a-9f33-7eaa-a633-ed6864f9d81f@sandeen.net>
Date: Thu, 4 Jan 2018 12:29:23 -0600
MIME-Version: 1.0
In-Reply-To: <151500483196.7713.13575201997749465948.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 1/3/18 12:40 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Call libxfs_ functions, not xfs_ functions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Oops, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

