Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5D8k95V223939 for <xfs@oss.sgi.com>; Mon, 13 Jun 2011 03:46:09 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E217D1B913CD
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2011 01:46:07 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id O59zlMMxYTEzEcJO
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2011 01:46:07 -0700 (PDT)
Received: by vws13 with SMTP id 13so3956783vws.26
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2011 01:46:02 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 Jun 2011 14:16:02 +0530
Message-ID: <BANLkTinCvmt+=ZO9HwUWda1vkmLEqOfSwg@mail.gmail.com>
Subject: xfstest run result on 2.6.35.13 X86, 51 test cases failed
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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
To: xfs@oss.sgi.com

Dear All.
I have installed the 2.6.35.13 long term valilla kernel release
(www.kenrel.org) on my Intel core 2 duo PC, and run 11-05-2011 xfstest
version, and run on it, below is the list of fails test cases.
As far as I know community uses xfstest for QA, seeing so many fails,
I am bit worried.
Can anyone hepl me know that why so many fails, is I missed some
config option ? or these test cases are not applicable ? or there is
someting else
12
13
18
30
31
49
73
74
76
78
79
80
82
84
104
109
111
112
113
129
133
136
167
170
171
172
173
174
178
180
181
189
195
198
200
202
207
208
210
211
216
224
229
239
240
241
242
247
250
251
252

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
