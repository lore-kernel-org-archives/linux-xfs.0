Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5EA767F63
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 08:17:03 -0500 (CDT)
Message-ID: <5141CDCD.6070801@sgi.com>
Date: Thu, 14 Mar 2013 08:17:01 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: 3.9-rc2 xfs panic
References: <5913647.851698.1363248364959.JavaMail.root@redhat.com>
In-Reply-To: <5913647.851698.1363248364959.JavaMail.root@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: CAI Qian <caiqian@redhat.com>
Cc: xfs@oss.sgi.com

On 03/14/13 03:06, CAI Qian wrote:
> This is easy to reproduce here,
>
> # ./check 111
>
> Bisecting is under way...
>


Right now, xfstests 111 will cause a panic. See thread:

	http://oss.sgi.com/archives/xfs/2013-03/msg00322.html


--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
