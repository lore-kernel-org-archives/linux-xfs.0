Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 393377CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 07:58:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 126868F807A
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 05:58:01 -0700 (PDT)
Received: from mail-yh0-f47.google.com (mail-yh0-f47.google.com
	[209.85.213.47]) by cuda.sgi.com with ESMTP id VlD5SmSYgHsj5YF2
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 13 May 2013 05:58:00 -0700 (PDT)
Received: by mail-yh0-f47.google.com with SMTP id i57so1522888yha.6
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 05:58:00 -0700 (PDT)
Message-ID: <1368449876.17134.10.camel@archie>
Subject: Re: [PATCH 0/3] Tmpfs support and fixes for tmpfs/nfs
From: Boris Ranto <ranto.boris@gmail.com>
Date: Mon, 13 May 2013 14:57:56 +0200
In-Reply-To: <1367503439-12827-1-git-send-email-ranto.boris@gmail.com>
References: <1367503439-12827-1-git-send-email-ranto.boris@gmail.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: ranto.boris@gmail.com, Boris Ranto <branto@redhat.com>

On Thu, 2013-05-02 at 16:03 +0200, ranto.boris@gmail.com wrote:
> Hi all,
> 
> This series contains three patches related to support of tmpfs file system in xfstests.
> 
> First patch provides the support itself. Second patch fixes a regression where ./check -nfs -n -g auto stopped working for nfs (and tmpfs) and the last patch changes the failure on empty exclude group to warning to simplify automated testing.
> 
> Regards,
> Boris
> 

Could this small patchset get any review, please?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
