Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Nov 2006 09:15:25 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAAHFEaG014172
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 09:15:16 -0800
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9DC05163E4
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 09:14:26 -0800 (PST)
Message-ID: <4554B36E.9030006@sandeen.net>
Date: Fri, 10 Nov 2006 11:14:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem performance drop in kernels 2.6.16+
References: <bde600590611090930g3ab97aq3c76d7bca4ec267f@mail.gmail.com>	 <4553F3C6.2030807@sandeen.net>	 <Pine.LNX.4.61.0611101259490.6068@yvahk01.tjqt.qr> <bde600590611100516u7b8ca1bfs74d3cc8b78eb3520@mail.gmail.com>
In-Reply-To: <bde600590611100516u7b8ca1bfs74d3cc8b78eb3520@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Igor A. Valcov" <viaprog@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Igor A. Valcov wrote:
> Below is a simplified version of the test program, and results of
> testing different kernels/filesystems/mount options. The results are a
> little different from the ones described in the initial post (this
> time performance decreased "only" 2 times), but the general tendency
> is clearly the same.

I imagine that I know the answer, but to be sure you might put some time
checks into your test app to see -which- portion of the test is taking
the bulk of the time.

-Eric
