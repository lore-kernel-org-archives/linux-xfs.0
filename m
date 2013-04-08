Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BFF2629DFA
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 22:40:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A0DD3304032
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 20:40:35 -0700 (PDT)
Received: from mail-pa0-f51.google.com (mail-pa0-f51.google.com
	[209.85.220.51]) by cuda.sgi.com with ESMTP id CJZDt0nbKt4lSkbs
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Apr 2013 20:40:34 -0700 (PDT)
Received: by mail-pa0-f51.google.com with SMTP id jh10so3025264pab.10
	for <xfs@oss.sgi.com>; Sun, 07 Apr 2013 20:40:34 -0700 (PDT)
Date: Mon, 8 Apr 2013 11:57:26 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v3] xfstests: add a new test case for ext4 indirect-based
	file
Message-ID: <20130408035725.GA32102@gmail.com>
References: <1364119002-17350-1-git-send-email-wenqing.lz@taobao.com>
	<515EE871.1060106@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <515EE871.1060106@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On Fri, Apr 05, 2013 at 10:06:25AM -0500, Rich Johnston wrote:
> Zheng,
> 
> Another nice patch that needs to be reworked so that the test
> resides in the tests/generic directory.  Don't worry about the test
> number, it will be adjusted to be the next in test group when
> committed.

Sorry for the late.  Yes, I am happy to rework this patch.

Regards,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
