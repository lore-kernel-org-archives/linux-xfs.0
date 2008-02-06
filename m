Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 17:15:22 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m161FExN009819
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 17:15:19 -0800
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8B86D9F266
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2008 17:15:37 -0800 (PST)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id 9B5AeFacX7ejkKHg for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 17:15:37 -0800 (PST)
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by ishtar.tlinx.org (8.13.3/8.12.10/SuSE Linux 0.7) with ESMTP id m161FaAJ017037
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 17:15:36 -0800
Message-ID: <47A90A38.3050206@tlinx.org>
Date: Tue, 05 Feb 2008 17:15:36 -0800
From: "Linda A. Walsh" <law@tlinx.org>
MIME-Version: 1.0
Subject: %inodes question
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Does this really matter much anymore?  It defaults to 25%, but
on a 1T disk, that's 250G "reserved"(?) for inodes?  Even 1%
still gives you 10G of inodes.
