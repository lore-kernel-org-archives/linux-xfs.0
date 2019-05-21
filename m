Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44378 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbfEUT1d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 15:27:33 -0400
Subject: Re: [PATCH 12/12] mkfs: enable reflink by default
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839428076.68606.9379127257564633311.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <738a7959-fb8b-a365-d7fa-01e17a6a9c4b@sandeen.net>
Date: Tue, 21 May 2019 14:27:32 -0500
MIME-Version: 1.0
In-Reply-To: <155839428076.68606.9379127257564633311.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 5/20/19 6:18 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Data block sharing (a.k.a. reflink) has been stable for a while, so turn
> it on by default.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I'm cool with this.  :)  But I think we need a manpage update too.
I also had some comment updates - I'll send a reply as a patch.

-Eric
