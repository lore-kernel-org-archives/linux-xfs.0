Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38130 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030837AbdDZVfT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 17:35:19 -0400
Subject: Re: [PATCH v2 4/4] xfs_db: dump metadata btrees via 'btdump'
References: <149186446125.32572.5134583964816531229.stgit@birch.djwong.org>
 <149186448580.32572.11952289934147703634.stgit@birch.djwong.org>
 <20170426203624.GA23371@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4375753a-610a-a60b-b99d-8f0f6f9d2369@sandeen.net>
Date: Wed, 26 Apr 2017 16:35:19 -0500
MIME-Version: 1.0
In-Reply-To: <20170426203624.GA23371@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 4/26/17 3:36 PM, Darrick J. Wong wrote:
> Introduce a new 'btdump' command that can print the contents of all
> blocks of any metadata subtree in the filesystem.  This enables
> developers and forensic analyst to view a metadata structure without
> having to navigate the btree manually.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good to me, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
