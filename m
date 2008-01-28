Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jan 2008 19:22:16 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0T3MADU011542
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2008 19:22:13 -0800
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED4B5D222F7
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2008 19:22:29 -0800 (PST)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id uIQNOYRCCGlQVnu3 for <xfs@oss.sgi.com>; Mon, 28 Jan 2008 19:22:29 -0800 (PST)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m0SLXrMM017416
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2008 13:33:53 -0800
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m0SLXlZh032537
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2008 13:33:48 -0800
Message-ID: <479E4A52.6000804@agami.com>
Date: Mon, 28 Jan 2008 13:34:10 -0800
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Extent merging past MAXEXTLEN
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: XFS Mailing List <xfs@oss.sgi.com>

Hi everyone,

Is there a reason to continue limiting extent merges past MAXEXTLEN
on 64-bit systems?

thanks,

    Mike
