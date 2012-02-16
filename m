Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GBp2ei250296 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 05:51:03 -0600
Received: from seldrel01.sonyericsson.com (seldrel01.sonyericsson.com
	[212.209.106.2]) by cuda.sgi.com with ESMTP id 1AGCzktYjHFXGbDX
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Feb 2012 03:51:01 -0800 (PST)
From: "Assarsson, Emil" <Emil.Assarsson@sonyericsson.com>
Date: Thu, 16 Feb 2012 12:50:57 +0100
Subject: XFS memory recomendation?
Message-ID: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA721CA3@seldmbx01.corpusers.net>
Content-Language: en-US
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

Are there any recommendations about how much memory I need based on the size of the file system and/or amount of files?
For example: how much memory would be optimal for a 20TB file system with 3000000 files? 

I guess it depends on the usage pattern?
Is there any way to make sure that the file allocation table stays in the memory?

Best regards
Emil Assarsson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
