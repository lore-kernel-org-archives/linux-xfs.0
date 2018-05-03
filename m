Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35794 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751505AbeECSr0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 May 2018 14:47:26 -0400
Subject: Re: [PATCH 2/9] libfrog: refactor fs geometry printing function
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
 <152401953658.13048.467837665188564402.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6b6005d3-81aa-41ce-9077-97170b8b09f8@sandeen.net>
Date: Thu, 3 May 2018 13:47:25 -0500
MIME-Version: 1.0
In-Reply-To: <152401953658.13048.467837665188564402.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 4/17/18 9:45 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the fs geometry printing function to libfrog so that mkfs and others
> can share.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
